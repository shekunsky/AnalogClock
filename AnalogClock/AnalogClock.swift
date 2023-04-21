//
//  AnalogClock.swift
//  AnalogClock
//
//  Created by Alex2 on 21.04.2023.
//

import SwiftUI

struct AnalogClock: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeLine in
            Canvas { ctx, size in
                let angles = getAngles(for: timeLine.date)
                let rect = CGRect(origin: .zero, size: size)
                let radius = min(size.width, size.height) / 2
                
                let border = radius / 25
                let hourLength = radius / 2.5
                let minuteLength = radius / 1.5
                let secondLength = radius * 1.1
                let secondWidth = radius / 25
                
                ctx.stroke(Circle()
                    .inset(by: border / 2)
                    .path(in: rect), with: .color(.primary), lineWidth: border)
                ctx.translateBy(x: rect.midX, y: rect.midY)
                
                drawHoursNumbers(in: ctx, radius: radius)
                
                drawHand(in: ctx, radius: radius, length: minuteLength, angle: angles.minute)
                drawHand(in: ctx, radius: radius, length: hourLength, angle: angles.hour)
                
                /// central ring
                let innerRing = radius / 6
                let ringWidth = radius / 40
                let inner = CGRect(x: -innerRing / 2, y: -innerRing / 2, width: innerRing, height: innerRing)
                
                ctx.stroke(Circle()
                    .path(in: inner), with: .color(.primary), lineWidth: ringWidth)
                
                /// seconds line
                let secondLine = Capsule()
                    .offset(x: 0, y: -radius / 6)
                    .rotation(angles.second, anchor: .top)
                    .path(in: CGRect(x: -secondWidth / 2, y: 0, width: secondWidth, height: secondLength))
                
                ctx.fill(secondLine, with: .color(.orange))
                
                /// ring for seconds line
                let centerPiece = Circle()
                    .path(in: inner.insetBy(dx: ringWidth, dy: ringWidth))
                ctx.blendMode = .clear
                ctx.fill(centerPiece, with: .color(.white))
                ctx.blendMode = .normal
                ctx.stroke(centerPiece, with: .color(.orange), lineWidth: ringWidth)
            }
        }
    }
    

    func getAngles(for date: Date) -> (hour: Angle, minute: Angle, second: Angle) {
        let parts = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: .now)
        let h = Double(parts.hour ?? 0)
        let m = Double(parts.minute ?? 0)
        let s = Double(parts.second ?? 0)
        let n = Double(parts.nanosecond ?? 0)
        
        var hour = Angle.degrees(30 * (h + m / 60) + 180)
        var minute = Angle.degrees(6 * (m + s / 60) + 180)
        var second = Angle.degrees(6 * (s + n / 1_000_000_000) + 180)
        
        if hour.radians == .pi { hour = .radians(3.14158) }
        if minute.radians == .pi { minute = .radians(3.14158) }
        if second.radians == .pi { second = .radians(3.14158) }
        
        return (hour, minute, second)
    }
    
    func drawHand(in context: GraphicsContext, radius: Double, length: Double, angle: Angle) {
        let width = radius / 30
        
        let stalk = Rectangle().rotation(angle, anchor: .top)
            .path(in: CGRect(x: -width / 2, y: 0, width: width, height: length))
        context.fill(stalk, with: .color(.primary))
        
        let hand = Capsule()
            .offset(x: 0, y: radius / 5)
            .rotation(angle, anchor: .top)
            .path(in: CGRect(x: -width, y: 0, width: width * 2, height: length))
        context.fill(hand, with: .color(.primary))
    }
    
    func drawHoursNumbers(in context: GraphicsContext, radius: Double) {
        let fontSize = radius / 4
        let textOffset = radius * 0.75
        
        for i in 1...12 {
            let text = Text(String(i)).font(.system(size: fontSize).bold())
            let point = CGPoint(x: 0, y: -textOffset)
                .applying(CGAffineTransform(rotationAngle: Double(i) * .pi / 6))
            context.draw(text, at: point)
        }
    }
}

struct AnalogClock_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
