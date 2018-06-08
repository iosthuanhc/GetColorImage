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
    @IBOutlet weak var colorView: NSView!
    @IBOutlet weak var colorWell1: NSColorWell!
    @IBOutlet weak var colorWell2: NSColorWell!
    @IBOutlet weak var colorWell3: NSColorWell!
    @IBOutlet weak var colorWell4: NSColorWell!
    @IBOutlet weak var colorWell5: NSColorWell!
    @IBOutlet weak var colorWell6: NSColorWell!
    @IBOutlet weak var colorWell7: NSColorWell!
    @IBOutlet weak var colorWell8: NSColorWell!
    
    var colorItems: [NSColor]?
    var pixDatas = [Pixel]()
    var pixDataSplits = [[Pixel]]()
    
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

    @IBAction func colorWell1_Action(_ sender: NSColorWell) {
        let pxs = getPixelsWithColor(color: sender.color)
        if pxs.count > 0 {
            
        }
    }
    
    @IBAction func colorWell2_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell3_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell4_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell5_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell6_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell7_Action(_ sender: NSColorWell) {
        
    }
    
    @IBAction func colorWell8_Action(_ sender: NSColorWell) {
        
    }
    
    func getPixelsWithColor(color: NSColor) -> [Pixel] {
        var pixels = [Pixel]()
        for item in pixDatas {
            if item.r == Float(color.redComponent), item.g == Float(color.greenComponent), item.b == Float(color.blueComponent) {
                pixels.append(item)
            }
        }
        return pixels
    }
    
    func updateUIWithImageUrl(url: URL) {
        colorItems = [NSColor]()
        imageView.image = NSImage(byReferencing: url)
        pixDatas = (imageView.image?.pixelData())!
        let index = pixDatas.count / 8
        pixDataSplits = pixDatas.splitArray(into: index)
        for item in pixDataSplits {
            colorItems?.append(item[item.count - 1].color)
        }
        fillClolorCell()
        tableView.reloadData()
    }
    
    func fillClolorCell() {
        colorWell1.color = colorItems![0]
        colorWell2.color = colorItems![1]
        colorWell3.color = colorItems![2]
        colorWell4.color = colorItems![3]
        colorWell5.color = colorItems![4]
        colorWell6.color = colorItems![5]
        colorWell7.color = colorItems![6]
        colorWell8.color = colorItems![7]
        /*
        colorView.subviews.forEach({ $0.removeFromSuperview() })
        var y = 0
        for item in 0..<(colorItems?.count ?? 0) {
            let color = NSColorWell(frame: CGRect(x: 0, y: y, width: 100, height: 28))
            color.color = colorItems![item]
            color.tag = item
            color.addObserver(self, forKeyPath: "\(color.tag)", options: .new, context: nil)
            colorView.addSubview(color)
            y = y + Int(color.frame.size.height) + 5
        }
 */
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "color" {
            
        }
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

extension Array {
    func splitArray(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
