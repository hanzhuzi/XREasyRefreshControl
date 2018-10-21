## XREasyRefreshControl

* An easy way to use pull-to-refresh
* A powerful and lightweight pull-down refresh and pull-up load control.,you can customize your personality refresh according to the requirements. 一款强大且支持自定制的iOS平台下，下拉刷新，上拉加载的刷新库。

* These `UIScrollView` categories makes it super easy to add pull-to-refresh and infinite scrolling fonctionalities to any `UIScrollView` (or any of its subclass). Like `UITableView`, `UICollectionView`, or `UIWebView` and `WKWebView`. Adding categories and methods to `UIScrollView` makes it easy to add refreshes to all subclasses of `UIScrollView`, yes, that's it!

通过为`UIScrollView`进行扩展，使得向任何有UIScrollView（或其任何子类）添加刷新header和刷新footer都将变得非常容易。像`UITableView`，`UICollectionView`，`UIWebView`以及`WKWebView`。

## How to Use `XREasyRefreshControl`(如何安装？)

### From CocoaPods

Add `pod  'XREasyRefreshControl'` to your Podfile.
* pod install
* import XREasyRefresh

Swift 4.2, Xcode 10. is supported in versions 1.2.1 and above.
(1.2.1版本以上支持Swift 4.2, Xcode 10.)
  
### Manual import

Download `XREasyRefreshControl` add the files in the `Source` directory to your project files.

### Supports(系统，语言支持)

* ARC
* Swift 4.2
* iOS 8.0
* Xcode 10 or Latter
* Fixed iPhoneX, XS, XS Max, XR
iPhone，iPad，Screen anyway.

## Usage

### Optional (global configuration)(刷新库全局配置)

add the code to `didFinishLaunchingWithOptions` function.
```swift

XRRefreshControlSettings.sharedSetting.configSettings(
            animateTimeForAdjustContentInSetTop: 0.5,
            animateTimeForEndRefreshContentInSetTop: 0.3,
            afterDelayTimeForEndInsetTopRefreshing: 0.5,
            pullLoadingMoreMode: .ignorePullReleaseFast,
            refreshStatusLblTextColor: XRRefreshControlSettings.colorFromRGB(hexRGB: 0x333333),
            refreshStatusLblTextFont: UIFont.systemFont(ofSize: 13))
	    
```

### Add refresh to UITableView(为UITableView添加header刷新和footer刷新)

```swift

// add header Refresh
mainTableView.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader(), heightForHeader: 65, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) {
	// do request...
}

// add footer Refresh
mainTableView.xr.addPullToRefreshFooter(refreshFooter: XRActivityRefreshFooter(), refreshingClosure: {
	// do request...
})

```
### Add refresh to UICollectionView(为UICollectionView添加header刷新和footer刷新)

```swift

// add header Refresh
mainCollectionVw.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader()) { 
	// do request...
}

// add footer Refresh
mainCollectionVw.xr.addPullToRefreshFooter(refreshFooter: XRActivityRefreshFooter(), refreshingClosure: {
	// do request...
})

```
### Add refresh to UIWebView(为UIWebView添加header刷新扩展)

```swift

// add header Refresh
webView.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader()) { [weak self] in
	if let weakSelf = self {
	   weakSelf.webView.reload()
	}
}

```
### Add refresh to WKWebView(为WKWebView添加header刷新扩展)

```swift

// add header Refresh
wk_webView.xr.addPullToRefreshHeader(refreshHeader: XRActivityRefreshHeader()) { [weak self] in
	if let weakSelf = self {
	   weakSelf.wk_webView.reload()
	}
}

```

### Auto dropdown refresh(自定进行header下拉刷新)

```swift

mainTableView.xr.beginHeaderRefreshing()

```

### End dropdown refresh(结束header刷新)

```swift

mainTableView.xr.endHeaderRefreshing()

```


### Add a pull-up load(为UITableView，UICollectionView，UIWebView, WKWebView，UIScrollView添加刷新footer)

```swift

mainTableView.xr.addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRActivityRefreshFooter(), heightForFooter: 55) {

	// do loading more request
}

```

### End the pull up load more(结束footer刷新)

```swift

mainTableView.xr.endFooterRefreshing()

```

### The end pull-up loads more, showing no more data(结束footer刷新，显示无更多数据提示)

```swift

mainTableView.xr.endFooterRefreshingWithNoMoreData()

```

### End the pull up load more, remove the pull up load more controls(结束footer刷新，并移除刷新footer)

```swift

mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()

```

### End the pull up load more, load failed, click reload(结束footer的刷新，显示加载失败，点击文字即可重新加载)

```swift

mainTableView.xr.endFooterRefreshingWithLoadingFailure()

```

### How to adapt iPhoneX, iPhoneXS, XR, and XS Max? (如何适配iPhone X...)

Very simple, you can specify the value of the `ignoreTopHeight` of `XRRefreshHeader`, and the value of `ignoreBottomHeight` of `XRRefreshFooter`, and `ignoreBottomHeight` is already adapted by default, no need to set, of course, you can also specify the value you want. Adaptation will become very simple.

非常简单，你可以指定 `XRRefreshHeader`的`ignoreTopHeight`, 以及 `XRRefreshFooter`的`ignoreBottomHeight`的值，而`ignoreBottomHeight`默认已经适配好了，无须设置，当然，你也可以指定你想要的值。适配将变得非常简单。

### Rendering(效果图)

![UITableView,UICollectionView](https://github.com/hanzhuzi/XREasyRefreshControl/blob/master/XREasyRefreshControl/demo1.gif)

![UIWebView,WKWebView](https://github.com/hanzhuzi/XREasyRefreshControl/blob/master/XREasyRefreshControl/demo2.gif)

![UIWebView,WKWebView](https://github.com/hanzhuzi/XREasyRefreshControl/blob/master/XREasyRefreshControl/demo3.gif)

### Customization(如何自定制刷新样式？)

You can inherit the base classes `XRBaseRefreshHeader` and `XRBaseRefreshFooter`, override `refreshStateChanged`, and, if necessary, override `progressvaluechanged` to customize the drop-down refresh and drop-down loading effects you want.

你可以通过继承 `XRBaseRefreshHeader` 和 `XRBaseRefreshFooter`这两个类，通过写很少的代码就可以自定制出你想要的下拉刷新，上拉加载样式，还可以通过 `progressvaluechanged`的值更精确得控制动画。

### Under the hood(实现原理)

XREasyRefreshControl extends `UIScrollView` by adding new public methods as well as a dynamic properties. 

It uses key-value observing to track the scrollView's `contentOffset` and `contentSize`.

### LICENSE

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.











