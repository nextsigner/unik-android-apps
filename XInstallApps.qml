import QtQuick 2.0
import QtQuick.Controls 2.0
import "qrc:/"

Item{
    id: xInstallApps
    width: app.width-app.fs*2
    height: app.height
    anchors.horizontalCenter: parent.horizontalCenter
    visible: xApp.mod===2
    Column{
        spacing: app.fs
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
        TextField{
            id: tiUrl
            width: parent.width-app.fs
            anchors.horizontalCenter: parent.horizontalCenter
            Keys.onReturnPressed: {
                if(text==='clean'){
                    appSettings.uArrayUrls = '|'
                    tiUrl.text = ''
                    return
                }
                updInstallApp.install()
            }
        }
        Row{
            spacing: app.fs
            UxBotCirc{
                id: botLoadUrls
                text: '\uf021'
                animationEnabled: false
                blurEnabled: false
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
                blurEnabled: false
                onClicked: {
                   updInstallApp.install()
                }
            }
        }
        UProgressDownload{
            id:updInstallApp
            width: app.width
            onDownloaded: {
                    let m0 = tiUrl.text.split('/')
                    let m1 =  m0[m0.length-1]
                    let m2 = m1.replace(".git", "").replace(".zip", "")

                    let params = '-folder='+pws+'/'+m2+', '

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
                    }

                    //xApp.mod=1
                    //xListApps.modView=2
            }
            function install(){
                if(appSettings.uArrayUrls.indexOf(tiUrl.text)<0){
                    appSettings.uArrayUrls+=tiUrl.text+'|'
                }
                updInstallApp.infoText = unikSettings.lang==='es'?'Instalando '+tiUrl.text+'...':'Installing '+tiUrl.text+'...'
                updInstallApp.download(tiUrl.text, pws)
            }
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
            blurEnabled: false
            onClicked: xApp.mod = 0
        }
    }
}
