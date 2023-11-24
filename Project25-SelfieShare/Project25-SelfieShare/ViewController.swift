//
//  ViewController.swift
//  Project25-SelfieShare
//
//  Created by Berserk on 23/11/2023.
//

import UIKit
import MultipeerConnectivity

class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate {
    
    // MARK: - Properties
    
    private var images = [UIImage]()
    private var collectionViewInset: CGFloat = 10.0
    
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    private var macSession: MCSession?
    private var mcAdvertiserAssistant: MCNearbyServiceAdvertiser?
    
    private let serviceType: String = "hws-project25"

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addMedia))
        
        let hostBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let connectedDevicesBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showConnectedDevices))
        navigationItem.leftBarButtonItems = [hostBarButton, connectedDevicesBarButton]
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        macSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        macSession?.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func addMedia() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "import a photo", style: .default, handler: importPicture))
        alertController.addAction(UIAlertAction(title: "send hello", style: .default, handler: sendText))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc private func importPicture(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func sendText(action: UIAlertAction) {
        
        guard let macSession = macSession else { return }
        if macSession.connectedPeers.count > 0 {
            
            let textData = Data("hello friend".utf8)
            
            do {
                try macSession.send(textData, toPeers: macSession.connectedPeers, with: .reliable)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func showConnectedDevices(action: UIAlertAction) {
        
        guard let macSession = macSession else { return }
        
        let devicesName = macSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
        
        let alertController = UIAlertController(title: "Peered devices", message: devicesName, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc private func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting(action:)))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession(action:)))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    private func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        mcAdvertiserAssistant?.delegate = self
        mcAdvertiserAssistant?.startAdvertisingPeer()
    }
    
    private func joinSession(action: UIAlertAction) {
        guard let mcSession = self.macSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        guard let macSession = macSession else { return }
        
        if macSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                
                do {
                    try macSession.send(imageData, toPeers: macSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
        
        images.append(image)
        
        dismiss(animated: true)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            let sectionInsets = layout.sectionInset
            let spacingBetweenItems = layout.minimumInteritemSpacing
            let numberOfColumns: Int = 2
            
            let totalSpacing = sectionInsets.left + spacingBetweenItems * (CGFloat(numberOfColumns) - 1) + sectionInsets.right
            
            let adjustedWidth = collectionView.frame.width - totalSpacing
            
            let cellWidth: CGFloat = adjustedWidth / CGFloat(numberOfColumns)
            
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        return CGSize(width: 145.0, height: 145.0)
    }
    
    // MARK: - MCBrowserViewController Delegate
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
        dismiss(animated: true)
    }
    
    // MARK: - MCNearbyServiceAdvertiser Delegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: title, message: "\(peerID.displayName)", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Allow", style: .default, handler: { [weak self] _ in
            invitationHandler(true, self?.macSession)
        }))
        ac.addAction(UIAlertAction(title: "Refuse", style: .destructive, handler: { [weak self] _ in
            invitationHandler(false, self?.macSession)
        }))
        present(ac, animated: true)
    }
    
    // MARK: - MCSession Delegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            // Challenge 1
            let alertController = UIAlertController(title: "Disconnected peer", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
            }
            print("Not connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state recevived: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.append(image)
                self?.collectionView.reloadData()
            } else if let text = String(data: data, encoding: .utf8) {
                let alertController = UIAlertController(title: peerID.displayName, message: text, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

