import QtQuick 2.0

Item{
    id: r
    anchors.fill: parent
    visible: xApp.mod===1
    onVisibleChanged: if(visible)lv.focus=true
    property int modView: 0
    onModViewChanged: {
        for(let i=0;i<lv.count;i++){
            if(lv.contentItem.children[i]){
                console.log('lv'+i+': '+lv.contentItem.children[i].objectName)
                if(r.modView===1){
                    if(lv.contentItem.children[i].installed){
                        lv.contentItem.children[i].visible = true
                        lv.contentItem.children[i].height = app.fs*3+unikSettings.borderWidth*2
                    }else{
                        lv.contentItem.children[i].visible = false
                    }
                }else  if(r.modView===2){
                    if(!lv.contentItem.children[i].installed){
                        lv.contentItem.children[i].visible = false//(''+fl.get(i, 'fileName')).indexOf('link')===0&&(''+fl.get(i, 'fileName')).indexOf('.ukl')>0
                        lv.contentItem.children[i].height = 0
                    }else{
                        lv.contentItem.children[i].visible = true
                        lv.contentItem.children[i].height = app.fs*3+unikSettings.borderWidth*2
                    }
                }else{
                    lv.contentItem.children[i].visible = (''+fl.get(i, 'fileName')).indexOf('link')===0&&(''+fl.get(i, 'fileName')).indexOf('.ukl')>0
                }
                /*if(lv.contentItem.children[i].visible){
                    lv.contentItem.children[i].height = app.fs*3+unikSettings.borderWidth*2
                }else{
                    lv.contentItem.children[i].height = 0
                }*/
            }
        }
    }
    Column{
        anchors.centerIn: parent
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
                text: r.modView===0?'\uf069 '+r.modView:r.modView===1?'\uf00c '+r.modView:'\uf019 '+r.modView
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
                    }else{
                        r.modView=0
                    }
                }
            }

        }
        ListView{
            id:lv
            width: r.width-app.fs
            height: r.height-app.fs*5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            model:fl
            delegate: delegate
            Component{
                id:delegate
                UxBotRect{
                    id:xItem
                    height: visible?app.fs*3+unikSettings.borderWidth*2:0
                    visible:r.modView!==2?(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0:installed
                    property bool installed: false
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    anchors.horizontalCenter: parent.horizontalCenter
                    animationEnabled: false
                    glowEnabled: false
                    onClicked: {
                        app.ca=app.al[index]
                        lv.currentIndex=index
                        run(fileName)
                    }
                    Component.onCompleted: {
                        app.al.push(fileName)
                        if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!app.prima){
                            app.ca=app.al[index]
                            app.prima=true
                            tap.color='black'
                            xP.visible=true
                        }
                        //if( tlaunch.enabled){
                        timerInit.restart()
                        //}
                        if(xItem.width>lv.width){
                            lv.width=xItem.width
                        }
                        var uklFileLocation=pws+'/'+fileName
                        xItem.installed=unik.fileExist(uklFileLocation)
                    }
                }                
            }
        }
    }
    function run(fileName){
        let uklLocation = pws+'/'+app.moduleName+'/'+fileName
        let uklData = unik.getFile(uklLocation).replace(/\n/g, '')
        let params = uklData.replace(/ /g, ', ')
        unik.setUnikStartSettings(params)
        //uLogView.showLog(fileName)
        if(Qt.platform.os==='android'){
            unik.restartApp()
        }else{
            unik.restartApp("")
        }
    }
}
