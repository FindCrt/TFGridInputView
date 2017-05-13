# TFGridInputView
[项目GitHub地址](https://github.com/ToFind1991/TFGridInputView)

###先来两张效果图

![多行+分开](http://upload-images.jianshu.io/upload_images/624048-192086ff8ed6f774.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![多行+紧贴+边框+圆角](http://upload-images.jianshu.io/upload_images/624048-3045749970e3dd28.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###开始
前几天朋友问我,怎么实现一个输入框的效果，设计图就是下面这张：

![一个输入框](http://upload-images.jianshu.io/upload_images/624048-b11e1fd613cd60dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当时觉得挺眼熟的，很多支付APP的支付密码就是这样输入的。

如果总结下，就是当你输入比较少的内容，而又希望整体比较美观的话，就会这样做，因为系统的UITextField会把内容挤在一起。

然后我就来了兴致，准备认真封装下，写一个对于这类输入框的通用控件。所以就有了[TFGridInputView](https://github.com/ToFind1991/TFGridInputView)

###目前的功能

* 可以像系统输入控件那样点击弹出键盘输入，通过`resignFirstResponder`来取消输入。

* 可以像系统控件那样通过`text`属性获取或设置文字。

* 具有密码输入功能，即不显示明文

* 支持边框和圆角

* 每个小框（cell）显示一个字符，可以设置它的显示样式：
  * 文字颜色和字体
  * 背景色或背景图片
* 可以给小框的不同状态设置不同的样式，现在有:
  * empty: 没有内容时
  * fill: 填充了内容时
  * highlight: 下一个要被输入的cell会被认为是highlight状态，类似于光标的作用。

如果设置了不同的样式，那么在输入的时候，可以直观的看到那些事输入的、那些是没输入的，输入位置也会比较醒目。当然这都是可以自由定义的，如果你不需要，可以把三种状态设为一样。

* 输入框的样式也有区别，目前有两种：
  * 一种就是每个cell是分开的，就像上面朋友给的需求那样。
  * 还一种是类似支付宝输入支付密码的样式，即一连串的紧贴的格子，如图。

![支付宝](http://upload-images.jianshu.io/upload_images/624048-3685ae22d06f6400.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###使用

在[项目代码](https://github.com/ToFind1991/TFGridInputView)里有详细的各种例子，欢迎直接看代码。这里给出一个简单示例：
```
//构建一个输入框
    _inputView = [[TFGridInputView alloc] initWithFrame:CGRectMake(30, 120, 100, 200) row:3 column:6];
    
    //构建一个样式，并调整各种格式
    TFGridInputViewCellStyle *style = [[TFGridInputViewCellStyle alloc] init];
    style.backColor = [UIColor colorWithWhite:0.9 alpha:1];
    style.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    //如果各个状态样式一致，可以只设置empty状态，它会作为缺省值使用
    [_inputView setStyle:style forState:(TFGridInputViewCellStateEmpty)];
    
    [self.view addSubview:_inputView];
    
    //设置边框和圆角
    _inputView.DIVBorderColor = [UIColor lightGrayColor];
    _inputView.DIVBorderWidth = 0.5;
    
    //设置圆角
    _inputView.DIVCornerRadius = 5;
    
    //设置布局样式
    _inputView.layoutStyle = TFGridInputViewLayoutStyleNoGap;
}
```
* 推荐使用带row、column的init方法构建，这样可以在初始化时候就把cell确定好，避免重复构建。
* 设置cell的各种状态需要的样式，如果你每种状态样式一直，就只需要设置empty状态即可。
*如果你还需要边框或圆角，也可以继续设置。

然后就可以使用了，大多数的工作都是在配置样式。

###关于布局规则

构建了一个`TFGridInputView`对象后，给了一个`frame`，但是可能cell的宽度加上cell之间的间隙会超过frame，比如宽度100，然后一行5个cell,cell宽度30，这样cell本身就占据了150的宽度了。

对于这种情况我的处理是：
**cell的大小不变，cell之间间隙使用最小值，然后反过来调整父视图的frame**

比如上面的情况，如果间隙是8，那么父视图的宽度会被扩充为：
30*5 + 8*(5+1) = 198。

这么做是因为：
* 如果你使用的时候设置不正确，那么我会帮你调整回来，只要你的cell大小和最小间隙是你需求的那样
* 如果你想自己控制，那么就可以先计算好，把正确的cell大小和间隙传递过来，这样就不会发生父视图的frame不够的问题，我这边就不会修改你原本的frame了。
* 在调整父视图的frame后，发出通知`TFGridInputViewLayoutNotification`，以便使用它的部分可以匹配修改

这样既有自由度，也不会麻烦。**需要的人需要，不需要的人不需要**。

**欢迎使用，欢迎star**
