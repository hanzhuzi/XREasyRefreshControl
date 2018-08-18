# XREasyRefreshControl

A powerful and lightweight pull-down refresh and pull-up load control.,you can customize your personality refresh according to the requirements.
These `UIScrollView` categories makes it super easy to add pull-to-refresh and infinite scrolling fonctionalities to any `UIScrollView` (or any of its subclass). Like `UITableView`, `UICollectionView`, or `UIWebView`. Adding categories and methods to `UIScrollView` makes it easy to add refreshes to all subclasses of `UIScrollView`, yes, that's it!

```swift

public func addPullToRefreshWithRefreshHeader(refreshHeader: XRBaseRefreshHeader, heightForHeader: CGFloat = 70, refreshingClosure refreshClosure:@escaping (() -> Swift.Void))

public func addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRBaseRefreshFooter, heightForFooter: CGFloat = 55, refreshingClosure refreshClosure:@escaping (() -> Swift.Void))

```

## Installation

### From CocoaPods

Add `pod  'XREasyRefreshControl'` to your Podfile.

## Usage

### Add a drop-down refresh

```swift

mainTableView.xr.addPullToRefreshWithRefreshHeader(refreshHeader: XRCircleAnimatorRefreshHeader(), heightForHeader: 70) {
       
	// do refresh request           
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











