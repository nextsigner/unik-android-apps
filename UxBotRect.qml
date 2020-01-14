import QtQuick 2.0
import QtGraphicalEffects 1.0
//import "qrc:/"
Item{
    id:r
    width: r2.width//+app.fs
    height: r2.height//+app.fs
    property string text:'text'
    property bool animationEnabled: true
    property bool glowEnabled: true
    property bool blurEnabled: true
    property int fontSize: app.fs
    property bool canceled: false
    property string t2
    property color backgroudColor: app.c1
    property color fontColor: app.c2
    property var objToRunQml
    property string qmlCode:''
    property int speed: 100
    signal clicked
    MouseArea{
        anchors.fill: r
    }
    onYChanged: {
        r2.touchEnabled = false
        timerUnlockTouch.restart()
    }
    Timer{
        id: timerUnlockTouch
        running: false
        repeat: false
        interval: 1500
        onTriggered: {
            r2.touchEnabled = true
        }
    }
    Glow {
        visible: r.glowEnabled
        anchors.fill: r2
        radius: 2
        samples: 28
        color: app.c1
        source: r2
        opacity: 1.0
    }
    BotonUX{
        id:  r2
        fontSize: r.fontSize
        canceled: r.canceled
        t2: r.t2
        backgroudColor: r.backgroudColor
        fontColor: r.fontColor
        objToRunQml: r.objToRunQml
        qmlCode: r.qmlCode
        speed: r.speed
        text: r.text
        anchors.centerIn: parent
        radius: width*0.5
        opacity: 0.5
        onPressedChanged: {
            glowPressed.visible=pressed
        }
        onClicked: {
            r.clicked()
            an1.stop()
            if(!r.animationEnabled)return
            tRestartAn1.restart()
        }
        Component.onCompleted:  {
            var nr = r.width*0.5
            children[0].radius= nr
            children[0].children[0].radius= nr
            children[0].children[1].radius= nr
            children[0].children[2].radius= nr

            children[0].children[0].border.width = app.fs*0.5
            children[0].children[1].border.width =app.fs*0.5
            children[0].children[2].border.width = app.fs*0.5
            r2.radius = nr
        }
    }
    FastBlur{
        id: blur
        width: r2.width+app.fs*0.5
        height: r2.height+app.fs*0.5
        anchors.centerIn: parent
        radius: app.fs*0.5
        source: r2
        clip: true
        visible: blurEnabled
        Timer{
            id:tRestartAn1
            repeat: false
            interval: 3000
            running: false
            onTriggered: an1.start()
        }
        SequentialAnimation{
            id: an1
            running: false//!r2.children[4].p
            loops: 3//Animation.Infinite
            onStopped: tRestartAn1.restart()
            NumberAnimation {
                target: blur
                property: "opacity"
                duration: 1000
                from: 0.0
                to: 1.0
                easing.type: Easing.InOutQuad
            }
            /*NumberAnimation {
                target: r2.children[0]
                property: "rotation"
                duration: 2000
                from: 0
                to: 180
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: r2.children[0]
                property: "rotation"
                duration: 2000
                from: 180
                to: 0
                easing.type: Easing.InOutExpo
            }*/
            NumberAnimation {
                target: blur
                property: "opacity"
                duration: 1500
                from: 1.0
                to: 0.0
                easing.type: Easing.InOutQuad
            }
        }
    }
    Glow {
        id: glowPressed
        visible: false
        anchors.fill: r2
        radius: 6
        samples: 17
        color: app.c2
        source: r2
        opacity: 1.0
    }
    Timer{
        id: tInit
        running: false
        repeat: false
        onTriggered: an1.start()
    }
    Component.onCompleted: {
        if(!animationEnabled)return
        var min = 0
        var max = 4
        let seconds   = Math.floor(Math.random()*(max-min+1)+min);
        console.log('UxBotCirc: '+unikSettings.lang)
        tInit.interval = seconds*1000
        tInit.start()
    }
}
