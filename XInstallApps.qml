import QtQuick 2.0
import QtQuick.Controls 2.0
import "qrc:/"

Item{
    id: r
    anchors.fill: parent
    visible: xApp.mod===2
    Column{
        spacing: app.fs
        width: r.width-app.fs
        anchors.centerIn: parent
        UText {
            id: labelInstallApp
            text: unikSettings.lang==='es'?'<b>Instalar App</b>':'<b>Install App</b>'
            font.pixelSize: app.fs*2
        }
        Item {
            width: 1
            height: app.fs
        }
        UText {
            id: labelUrl
            text: 'Url: '//+botLoadUrls.currentUrlIndex
            font.pixelSize: app.fs*2
        }
        Rectangle{
            width: parent.width
            height: r.height*0.2
            color: 'transparent'
            border.width: unikSettings.borderWidth*0.5
            border.color: app.c2
            TextInput{
                id: tiUrl
                width: parent.width-app.fs
                height: parent.height-app.fs
                anchors.centerIn: parent
                font.pixelSize: app.fs*1.5
                color: app.c2
                wrapMode: Text.WrapAnywhere
                Keys.onReturnPressed: {
                    if(text==='clean'){
                        appSettings.uArrayUrls = '|'
                        tiUrl.text = ''
                        return
                    }
                    updInstallApp.install()
                }
            }
        }
        Row{
            spacing: app.fs
            UxBotCirc{
                id: botLoadUrls
                text: '\uf021'
                animationEnabled: false
                property int currentUrlIndex: 0
                onClicked: {
                    let m0 = appSettings.uArrayUrls.split('|')
                    if(currentUrlIndex+1<m0.length-1){
                        currentUrlIndex++
                    }else{
                        currentUrlIndex=0
                    }
                    tiUrl.text = m0[currentUrlIndex]
                }
            }
            UxBotCirc{
                text: '\uf019'
                animationEnabled: false
                onClicked: {
                    updInstallApp.install()
                }
            }
        }
    }
    UProgressDownload{
        id:updInstallApp
        width: app.width
        anchors.bottom: r.bottom
        onDownloaded: {
            let m0 = tiUrl.text.split('/')
            let m1 =  m0[m0.length-1]
            let m2 = m1.replace(".git", "").replace(".zip", "")
            xConfirmStart.uAppInstalled = m2
            xConfirmStart.visible = true
            /*let params = '-folder='+pws+'/'+m2+', '

            if(uDownloadRequestUrl.indexOf('http')>=0&&uDownloadRequestUrl.indexOf('.git')>0){
                unik.setFile(pws+'/link_'+m2+'.ukl', '-git='+uDownloadRequestUrl)
                params +=  '-git='+uDownloadRequestUrl
            }
            infoText = '1:'+uDownloadRequestUrl+' 2:'+uDownloadRequestFolder+' 3:'+m2+' 4:'+pws
            unik.setUnikStartSettings(params)
            if(Qt.platform.os==='android'){
                unik.restartApp()
            }else{
                unik.restartApp("")
            }*/
        }
        function install(){
            if(appSettings.uArrayUrls.indexOf(tiUrl.text)<0){
                appSettings.uArrayUrls+=tiUrl.text+'|'
            }
            updInstallApp.infoText = unikSettings.lang==='es'?'Instalando '+tiUrl.text+'...':'Installing '+tiUrl.text+'...'
            updInstallApp.download(tiUrl.text, pws)
        }
    }

    Item{
        width: app.width-app.fs
        height: app.fs*2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        //anchors.topMargin: app.fs
        UxBotCirc{
            text: '\uf060'
            animationEnabled: false
            onClicked: xApp.mod = 0
        }
    }
    Rectangle{
        id: xConfirmStart
        width: parent.width
        height: colConfirmStart.height+app.fs*2
        color: app.c1
        border.width: unikSettings.borderWidth*0.5
        border.color: app.c2
        visible: false
        property string uAppInstalled: ''
        onVisibleChanged: {
            if(!visible)updInstallApp.opacity=0.0
        }
        Column{
            id: colConfirmStart
            spacing: app.fs
            anchors.centerIn: parent
            UText {
                id: labelConfirmStart
                font.pixelSize: app.fs*1.5
                width: xConfirmStart.width-app.fs
                text: unikSettings.lang==='es'?'<b>'+xConfirmStart.uAppInstalled+'</b> se ha instalado.<br />Desea iniciar la aplicación ahora?':'<b>'+xConfirmStart.uAppInstalled+'</b> was installed.<br />Do you want to start the application now?'
                wrapMode: Text.WordWrap
            }
            Row{
                spacing: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                UxBotRect{
                    text: 'NO'
                    animationEnabled: false
                    blurEnabled: false
                    onClicked: {
                        xConfirmStart.visible = false
                    }
                }
                UxBotRect{
                    text: unikSettings.lang==='es'?'SI':'YES'
                    animationEnabled: false
                    blurEnabled: false
                    onClicked: {
                        let m0 = updInstallApp.uDownloadRequestUrl.split('/')
                        let m1 =  m0[m0.length-1]
                        let m2 = m1.replace(".git", "").replace(".zip", "")

                        let params = '-folder='+pws+'/'+m2+', '

                        if(updInstallApp.uDownloadRequestUrl.indexOf('http')>=0&&updInstallApp.uDownloadRequestUrl.indexOf('.git')>0){
                            unik.setFile(pws+'/link_'+m2+'.ukl', '-git='+updInstallApp.uDownloadRequestUrl)
                            params +=  '-git='+updInstallApp.uDownloadRequestUrl
                        }
                        unik.setUnikStartSettings(params)
                        if(Qt.platform.os==='android'){
                            unik.restartApp()
                        }else{
                            unik.restartApp("")
                        }
                    }
                }
            }
        }
    }
}
