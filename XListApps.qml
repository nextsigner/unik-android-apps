import QtQuick 2.0

Item{
    id: r
    anchors.fill: parent
    visible: xApp.mod===1
    onVisibleChanged: if(visible)lv.focus=true
    property int modView: 0
    Column{
        anchors.top: r.top
        anchors.topMargin: app.fs*2
        Item{
            id: xBotListApps
            width: app.width
            height: app.fs*3
            UxBotCirc{
                text: '\uf060'
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.left:  parent.left
                anchors.leftMargin: app.fs
                onClicked: xApp.mod = 0
            }
            UxBotCirc{
                property var arrayIcon: ['\uf069', '\uf00c', '\uf019', '\uf07b']
                text: arrayIcon[r.modView]
                fontSize: app.fs
                animationEnabled: false
                blurEnabled: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right:  parent.right
                anchors.rightMargin: app.fs
                onClicked: {
                    if(r.modView===0){
                        r.modView=1
                    }else  if(r.modView===1){
                        r.modView=2
                    }else  if(r.modView===2){
                        r.modView=3
                    }else{
                        r.modView=0
                    }
                }
            }

        }
        ListView{
            id:lv
            visible: r.modView!==3
            width: r.width-app.fs
            height: r.height-app.fs*5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            model:fl
            delegate: r.modView!==1 ? delegate : delegateInstalled
            Component{
                id:delegateInstalled
                UxBotRect{
                    id:xItemInstalled
                    height: app.fs*3+unikSettings.borderWidth*2
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    anchors.horizontalCenter: parent.horizontalCenter
                    animationEnabled: false
                    glowEnabled: false
                    onClicked: {
                        run(fileName)
                    }
                    Component.onCompleted:  {
                        let uklLocation = pws+'/'+fileName
                        let uklData = ''+unik.getFile(uklLocation)
                        if(uklData.indexOf('-folder=')>=0){
                            let m0 = (''+uklData).split('-folder=')
                            if(m0.length>0){
                                let m1=(''+m0[1]).split('-folder=')
                                let m2=(''+m1[1]).split(' ')
                                xItemInstalled.text+=' -'+m2[0]
                                if(unik.fileExist(pws+'/'+m2[0]+'/main.qml')){
                                    xItemInstalled.visible=true
                                    xItemInstalled.height=app.fs*3+unikSettings.borderWidth*2
                                }else{
                                    xItemInstalled.visible=false
                                    xItemInstalled.height=0
                                }
                            }
                        }else{
                            let mn = (''+fileName).replace('link_', '').replace('.ukl', '')
                            if(unik.fileExist(pws+'/'+mn+'/main.qml')){
                                xItemInstalled.visible=true
                                xItemInstalled.height=app.fs*3+unikSettings.borderWidth*2
                            }else{
                                xItemInstalled.visible=false
                                xItemInstalled.height=0
                            }
                        }
                    }
                }
            }
            Component{
                id:delegate
                UxBotCirc{
                    id:xItem
                    //height: app.fs*3+unikSettings.borderWidth*2
                    visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    anchors.horizontalCenter: parent.horizontalCenter
                    animationEnabled: false
                    glowEnabled: false
                    onClicked: {
                        run(fileName)
                    }
                    Component.onCompleted: {

                        //if( tlaunch.enabled){
                        timerInit.restart()
                        //}
                        if(xItem.width>lv.width){
                            lv.width=xItem.width
                        }
                        var uklFileLocation=pws+'/'+fileName
                        //xItem.installed=unik.fileExist(uklFileLocation)
                    }
                }
            }
        }
        ListView{
            id:lvAppsFolders
            visible: r.modView===3
            width: r.width-app.fs
            height: r.height-app.fs*5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            model:flFolders
            delegate: delegateFolder
            Component{
                id:delegateFolder
                UxBotRect{
                    id:xItemFolder
                    height: app.fs*3+unikSettings.borderWidth*2
                    text: (''+fileName)//.substring(5, (''+fileName).length-4)
                    anchors.horizontalCenter: parent.horizontalCenter
                    animationEnabled: false
                    glowEnabled: false
                    onClicked: {
                        runFolder(unik.currentFolderPath().replace('/unik-android-apps', '')+'/'+fileName)
                    }
                    Component.onCompleted:  {
                        let mainQml = unik.currentFolderPath().replace('/unik-android-apps', '')+'/'+fileName
                        if(unik.fileExist(mainQml)){
                            xItemFolder.visible=true
                            xItemFolder.height=app.fs*3+unikSettings.borderWidth*2
                        }else{
                            xItemFolder.visible=false
                            xItemFolder.height=0
                        }
                    }
                }
            }
        }
    }
    function run(fileName){
        let uklLocation = pws+'/'+app.moduleName+'/'+fileName
        let uklData = unik.getFile(uklLocation).replace(/\n/g, '')
        if(!unik.fileExist(pws+'/'+fileName)){
            unik.sendFile(pws+'/'+fileName, uklData)
        }
        let params = uklData.replace(/ /g, ', ')
        unik.setUnikStartSettings(params)
        //uLogView.showLog(fileName)
        if(Qt.platform.os==='android'){
            unik.restartApp()
        }else{
            unik.restartApp("")
        }
    }
    function runFolder(folder){
        let params = '-folder='+folder
        unik.setUnikStartSettings(params)
        //uLogView.showLog(folder)

        if(Qt.platform.os==='android'){
            unik.restartApp()
        }else{
            unik.restartApp("")
        }
    }
}
