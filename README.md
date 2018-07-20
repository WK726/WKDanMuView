


# WKDanMuView
简单封装了弹幕的展示view，并且对外暴露了可以定制弹幕，以及点击之后效果的接口


-(void)pause;


调用pause方法，实现弹幕的暂停。


-(void)resume;


调用resume，实现弹幕的开始弹出。



models:弹幕的数据源。



WKDanmuViewProcotol中:


-(void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;


暴露弹幕的点击事件,放到viewcontroller中去处理点击之后的其他需求


# ViewController
这是弹幕的展示controller


实现WKDanMuView 的代理方法：


//返回当前的时间


-(NSTimeInterval)currentTime；


//根据项目的需求，可以自己去定制返回的UIView


-(UIView *)danmuViewWithModel:(WKDanmuModel *)model;


//点击的处理，定制点击之后的处理。


-(void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;



同时我在


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event


方法中模拟了给models填充数据的过程。
