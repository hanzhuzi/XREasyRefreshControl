## XREasyRefreshControl

* An easy way to use pull-to-refresh
* A powerful and lightweight pull-down refresh and pull-up load control.,you can customize your personality refresh according to the requirements.

* These `UIScrollView` categories makes it super easy to add pull-to-refresh and infinite scrolling fonctionalities to any `UIScrollView` (or any of its subclass). Like `UITableView`, `UICollectionView`, or `UIWebView` and `WKWebView`. Adding categories and methods to `UIScrollView` makes it easy to add refreshes to all subclasses of `UIScrollView`, yes, that's it!

## How to Use `XREasyRefreshControl`

### From CocoaPods

Add `pod  'XREasyRefreshControl'` to your Podfile.
* pod install
* import XREasyRefresh

### Manual import

Download `XREasyRefreshControl` add the files in the `Source` directory to your project files.

### Supports

* >= Swift 3.2
* >= iOS 8.0
* Xcode 9.3 or Latter

## Usage

### Add refresh to UITableView

```swift

// add header Refresh
mainTableView.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader(), heightForHeader: 65) {
	// do request...
}

// add footer Refresh
mainTableView.xr.addPullToRefreshFooter(refreshFooter: CustomActivityRefreshFooter(), refreshingClosure: {
	// do request...
})

```
### Add refresh to UICollectionView

```swift

// add header Refresh
mainCollectionVw.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { 
	// do request...
}

// add footer Refresh
mainCollectionVw.xr.addPullToRefreshFooter(refreshFooter: CustomActivityRefreshFooter(), refreshingClosure: {
	// do request...
})

```
### Add refresh to UIWebView

```swift

// add header Refresh
webView.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { [weak self] in
	if let weakSelf = self {
	   weakSelf.webView.reload()
	}
}

```
### Add refresh to WKWebView

```swift

// add header Refresh
wk_webView.xr.addPullToRefreshHeader(refreshHeader: CustomActivityRefreshHeader()) { [weak self] in
	if let weakSelf = self {
	   weakSelf.wk_webView.reload()
	}
}

```

### Auto dropdown refresh

```swift

mainTableView.xr.beginHeaderRefreshing()

```

### End dropdown refresh

```swift

mainTableView.xr.endHeaderRefreshing()

```


### Add a pull-up load

```swift

mainTableView.xr.addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRActivityRefreshFooter(), heightForFooter: 55) {

	// do loading more request
}

```

### End the pull up load more

```swift

mainTableView.xr.endFooterRefreshing()

```

### The end pull-up loads more, showing no more data

```swift

mainTableView.xr.endFooterRefreshingWithNoMoreData()

```

### End the pull up load more, remove the pull up load more controls

```swift

mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()

```

### End the pull up load more, load failed, click reload

```swift

mainTableView.xr.endFooterRefreshingWithLoadingFailure()

```

### Rendering

![UITableView,UICollectionView](https://github.com/hanzhuzi/XREasyRefreshControl/blob/master/XREasyRefreshControl/demo1.gif)

![UIWebView,WKWebView](https://github.com/hanzhuzi/XREasyRefreshControl/blob/master/XREasyRefreshControl/demo2.gif)

### Customization

You can inherit the base classes `XRBaseRefreshHeader` and `XRBaseRefreshFooter`, override `refreshStateChanged`, and, if necessary, override `progressvaluechanged` to customize the drop-down refresh and drop-down loading effects you want.

### Under the hood

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











