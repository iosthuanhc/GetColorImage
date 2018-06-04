//
//  ViewController.swift
//  DetectColorApp
//
//  Created by Ha Cong Thuan on 6/4/18.
//  Copyright © 2018 Ha Cong Thuan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var tableView: NSTableView!
    var colorItems: [NSColor]?
    
    private var currentImageUrl: URL? {
        didSet {
            if let url = currentImageUrl {
                updateUIWithImageUrl(url: url)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func updateUIWithImageUrl(url: URL) {
        colorItems = [NSColor]()
        imageView.image = NSImage(byReferencing: url)
        let pixData = imageView.image?.pixelData()
        pixData?.forEach({ (px) in
            colorItems?.append(px.color)
        })
        tableView.reloadData()
    }
    
    @IBAction func getImage(_ sender: Any) {
        getImage()
    }
    
    func getImage() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["png","jpg","jpeg","tif","tiff","psd","pdf"]
        panel.runModal()
        
        if let url = panel.url {
            self.currentImageUrl = url
        }
    }

}

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return colorItems?.count ?? 0
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let item = colorItems?[row] else {
            return nil
        }
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "Color \(item.description)"
            cell.textField?.textColor = item
            cell.imageView?.wantsLayer = true
            cell.imageView?.layer?.backgroundColor = item.cgColor
            return cell
        }
        return nil
    }
    
}

extension NSImage {
    
    func pixelData() -> [Pixel] {
        let bmp = self.representations[0] as! NSBitmapImageRep
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        var r, g, b, a: UInt8
        var pixels: [Pixel] = []
        
        for row in 0..<bmp.pixelsHigh {
            for col in 0..<bmp.pixelsWide {
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                pixels.append(Pixel(r: r, g: g, b: b, a: a, row: row, col: col))
            }
        }
        return pixels
    }
}

struct Pixel {
    
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    var row: Int
    var col: Int
    
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8, row: Int, col: Int) {
        self.r = Float(r)
        self.g = Float(g)
        self.b = Float(b)
        self.a = Float(a)
        self.row = row
        self.col = col
    }
    
    var color: NSColor {
        return NSColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a/255.0))
    }
    
    var description: String {
        return "RGBA(\(r), \(g), \(b), \(a))"
    }
    
}
