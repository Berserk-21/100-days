//
//  ViewController.swift
//  Project25-SelfieShare
//
//  Created by Berserk on 23/11/2023.
//

import UIKit
import MultipeerConnectivity

class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate {
    
    private var images = [UIImage]()
    private var collectionViewInset: CGFloat = 10.0
    
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    private var macSession: MCSession?
    private var mcAdvertiserAssistant: MCNearbyServiceAdvertiser?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        macSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        macSession?.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting(action:)))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession(action:)))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    private func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcAdvertiserAssistant?.delegate = self
        mcAdvertiserAssistant?.startAdvertisingPeer()
    }
    
    private func joinSession(action: UIAlertAction) {
        guard let mcSession = self.macSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
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
        ac.addAction(UIAlertAction(title: title, style: .destructive, handler: { [weak self] _ in
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
            print("Not connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown state recevived: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
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

