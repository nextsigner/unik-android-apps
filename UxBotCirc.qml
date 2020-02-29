import QtQuick 2.0
import QtGraphicalEffects 1.0
Item{
    id:r
    width: 50
    height: width
    clip: true
    property string text:'text'
    property bool animationEnabled: true
    property int padding: 0
    property alias bg: r2.bg
    property int fontSize: width*0.5
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

    BotonUX{
        id:  r2
        clip: true
        width: r.width
        height: width
        fontSize: r.fontSize
        padding: r.padding
        fontFamily: "FontAwesome"
        canceled: r.canceled
        t2: r.t2
        backgroudColor: r.backgroudColor
        fontColor: r.fontColor
        objToRunQml: r.objToRunQml
        qmlCode: r.qmlCode
        speed: r.speed
        text: r.text
        anchors.centerIn: r
        radius: width*0.5
        opacity: 0.75
        onClicked: {
            r.clicked()
            an1.stop()
            if(!r.animationEnabled)return
            tRestartAn1.restart()
        }
        Component.onCompleted: {
            var nr = r.width*0.5
            children[0].radius= nr
            children[0].children[0].radius= nr
            children[0].children[1].radius= nr
            children[0].children[2].radius= nr

            children[0].children[0].border.width = r.width*0.025
            children[0].children[1].border.width =r.width*0.025
            children[0].children[2].border.width = r.width*0.025
            r2.radius = nr
        }
    }
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
            target: r2
            property: "opacity"
            duration: 2000
            from: 0.75
            to: 1.0
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
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
        }
        NumberAnimation {
            target: r2
            property: "opacity"
            duration: 2000
            from: 1.0
            to: 0.75
            easing.type: Easing.InOutQuad
        }
    }
    Timer{
        id: tinit2
        running: false
        repeat: false
        onTriggered: an1.start()
    }
    Component.onCompleted: {
        if(!animationEnabled)return
        var min = 0
        var max = 4
        let seconds   = Math.floor(Math.random()*(max-min+1)+min);
        //console.log('UxBotCirc: '+unikSettings.lang)
        tinit2.interval = seconds*1000
        tinit2.start()
    }
}
