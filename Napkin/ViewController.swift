//
//  ViewController.swift
//  Napkin
//
//  Created by Cameron Hotchkies on 12/4/14.
//  Copyright (c) 2015 Srs Biznas. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var url: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var codeWindow: NSTextView!
    @IBOutlet weak var tableViewContainer: NSView!
    @IBOutlet weak var codeWindowContainer: NSView!
    @IBOutlet weak var emptyToNull: NSButton!
    @IBOutlet weak var sortDictKeys: NSButton!
    @IBOutlet weak var segment: NSSegmentedControl!
    
    var parser: UrlParser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadCodeWindow() {
        if (parser != nil) {
            let emptyVal = segment.selectedSegment == 1 ? "None" : "null"
            let oldQuote = "\""
            let newQuote = "\\\""
            
            let sortedArgs = sorted(parser!.arguments()) {self.sortDictKeys.state == NSOnState ? $0["key"]! < $1["key"] : false}
            
            let combined = sortedArgs.map {
                (res: [String: String]) -> String in
                let key = res["key"]!
                
                var entryValue = emptyVal
                
                if (self.emptyToNull.state == NSOffState || countElements(res["value"]!) > 0) {
                    let escaped = res["value"]!.stringByReplacingOccurrencesOfString(oldQuote, withString: newQuote)
                    entryValue =  "\"\(escaped)\""
                }
                
                return NSString(format: "\"\(key)\": \(entryValue)")
            }
            
            let joined = ",\n  ".join(combined)
            
            codeWindow.string = "{\n  \(joined)\n}"
        }
    }
    
    @IBAction func emptyToNullChanged(e2n: NSButton) {
        loadCodeWindow()
    }
    
    @IBAction func sortDictKeysChanged(_: AnyObject) {
        loadCodeWindow()
    }
    
    @IBAction func viewChanged(segments: NSSegmentedControl) {
        
        let showTable = (segments.selectedSegment == 0)
        
        codeWindowContainer.hidden = showTable
        tableViewContainer.hidden = !showTable
        emptyToNull.hidden = showTable
        sortDictKeys.hidden = showTable
        
        if segments.selectedSegment >= 1 {
            if (segments.selectedSegment == 1) {
                emptyToNull.title = "convert empty to None"
            } else if (segments.selectedSegment == 2) {
                emptyToNull.title = "convert empty to null"
            }
        
            loadCodeWindow()
        }
    }
    
    @IBAction func separateUrl(_: AnyObject) {
        let urlString = url.stringValue
    
        self.parser = UrlParserImpl(rawUrl: urlString)
        
        self.loadCodeWindow()
        
        self.tableView.reloadData()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if parser == nil {
            return 0
        }
        else
        {
            return parser!.arguments().count
        }
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn: NSTableColumn, row: Int) -> NSView
    {
        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(viewForTableColumn.identifier, owner: self) as NSTableCellView

        cellView.textField?.selectable = true
        
        var rowValue = parser!.arguments()[row]
        cellView.textField?.stringValue = rowValue[viewForTableColumn.identifier]!
        
        return cellView
    }
}

