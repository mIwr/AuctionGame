import UIKit

extension UILabel
{
    func animateNumberEdit(begin: Int64, end: Int64, numberFormating: ((Int64) -> String)?, animationInterval: TimeInterval, animationSteps: Int, completion: (() -> Void)?)
    {
        if let g_formatter = numberFormating
        {
            text = g_formatter(begin)
        }
        else
        {
            text = String(begin)
        }
        let delta = abs((end - begin) / Int64(animationSteps))
        let animStepInterval: TimeInterval = animationInterval / Double(animationSteps)
        var userInfo: [String: Any] = [:]
        userInfo["begin"] = begin
        userInfo["end"] = end
        userInfo["delta"] = delta
        userInfo["stockTag"] = tag
        userInfo["formatter"] = numberFormating
        userInfo["completion"] = completion
        self.tag = Int(begin)
        Timer.scheduledTimer(timeInterval: animStepInterval, target: self, selector: #selector(numEditTick(_:)), userInfo: userInfo, repeats: true)
    }
    
    @objc fileprivate func numEditTick(_ timer: Timer)
    {
        let data: [String: Any] = timer.userInfo as? [String: Any] ?? [:]
        let begin: Int64 = data["begin"] as? Int64 ?? 0
        let end: Int64 = data["end"] as? Int64 ?? 0
        var delta: Int64 = data["delta"] as? Int64 ?? 0
        if (delta == 0)
        {
            delta = 1
        }
        let formatter: ((Int64) -> String)? = data["formatter"] as? ((Int64) -> String)
        let completion: (() -> Void)? = data["completion"] as? (() -> Void)
        var currValue: Int64 = Int64(self.tag)
        
        let plus = end > begin
        if (plus)
        {
            currValue += delta
        }
        else
        {
            currValue -= delta
        }
        self.tag = Int(currValue)
        if let g_formatter = formatter
        {
            self.text = g_formatter(currValue)
            if ((plus && currValue >= end) || (!plus && currValue <= end))
            {
                self.text = g_formatter(end)
                self.tag = data["stockTag"] as? Int ?? 0
                timer.invalidate()
                completion?()
            }
        }
        else
        {
            self.text = String(currValue)
            if ((plus && currValue >= end) || (!plus && currValue <= end))
            {
                self.text = String(end)
                self.tag = data["stockTag"] as? Int ?? 0
                timer.invalidate()
                completion?()
            }
        }
    }
}
