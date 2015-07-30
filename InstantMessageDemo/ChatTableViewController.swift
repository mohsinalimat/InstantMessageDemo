//
//  ChatTableViewController.swift
//  InstantMessageDemo
//
//  Created by 游义男 on 15/7/29.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController,XxDl {

    @IBAction func compossing(sender: UITextField) {
        //构建XML元素 message
        var xmlmessage = DDXMLElement.elementWithName("message") as! DDXMLElement
        //增加属性""
        xmlmessage.addAttributeWithName("to", stringValue: toBuddyName)
        xmlmessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
        //构建正在输入的元素
        var compossing = DDXMLElement.elementWithName("compossing") as! DDXMLElement
        compossing.addAttributeWithName("xmlns", stringValue: "http://jabber.org/protocol/chatstates")
        
        //消息的子节点中加入正文
        xmlmessage.addChild(compossing)
        //通过通到发送XML文本
        zdl().xs!.sendElement(xmlmessage)
    }
    @IBAction func send(sender: UIBarButtonItem) {
        //获取聊天框文本
        let msgStr = msgTF.text
        //如果文本不为空
        if (!msgStr.isEmpty){
            //构建XML元素 message
            var xmlmessage = DDXMLElement.elementWithName("message") as! DDXMLElement
            //增加属性""
            xmlmessage.addAttributeWithName("type", stringValue: "chat")
            xmlmessage.addAttributeWithName("to", stringValue: toBuddyName)
            xmlmessage.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("weixinID"))
            //构建正文
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(msgStr)
            
            //消息的子节点中加入正文
            xmlmessage.addChild(body)
            //通过通道发送XML文本
            zdl().xs!.sendElement(xmlmessage)
            //清空聊天框
            msgTF.text = ""
            //保存自己的消息
            var msg = WXMessage()
            msg.isMe = true
            msg.body = msgStr
            
            //加入到聊天记录中
            msgList.append(msg)
            //通知表格刷新
            self.tableView.reloadData()
        }
    }

    
    @IBOutlet weak var msgTF: UITextField!
    //聊天的好友用户名
    var toBuddyName = ""
    
    // 聊天消息数组
    var msgList = [WXMessage]()
    
    //聊天记录
    func newMsg(aMsg: WXMessage) {
        //对方正在输入
        if (aMsg.isCompossing){
            self.navigationItem.title = "对面正在输入..."
        }
        // 如果有正文
        if (aMsg.body != ""){
            //显示更谁聊天
            self.navigationItem.title = toBuddyName
            //则加入到未读消息组，通知表格刷新
            msgList.append(aMsg)
            //控制表格刷新
            self.tableView.reloadData()
        }
    }

    
    //获取总代理
    func zdl() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接管消息代理
        zdl().xxDl = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return msgList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell

        //去对应的消息
        let msg = msgList[indexPath.row]
        //对单元格文本格式做一个调整
        if (msg.isMe){
            //本人所发信息聚友，灰色
            cell.textLabel?.textAlignment = .Right
            cell.textLabel?.textColor = UIColor.grayColor()
            
        }else{
            // 好友消息，橙色
            cell.textLabel?.textColor = UIColor.orangeColor()
            
        }
        //设定单元格的文本
        cell.textLabel?.text = msg.body

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
