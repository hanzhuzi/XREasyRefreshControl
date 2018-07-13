# XREasyRefreshControl

A powerful and lightweight pull-down refresh and pull-up load control.,you can customize your personality refresh according to the requirements.
These UIScrollView categories makes it super easy to add pull-to-refresh and infinite scrolling fonctionalities to any UIScrollView (or any of its subclass). Adding classes and methods to UIScrollView makes it easy to add refreshes to all subclasses of UIScrollView, yes, that's it!

```swift

public func xr_addPullToRefreshWithRefreshHeader(refreshHeader: XRBaseRefreshHeader, heightForHeader: CGFloat = 70, refreshingClosure refreshClosure:@escaping (() -> Swift.Void))

public func xr_addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRBaseRefreshFooter, heightForFooter: CGFloat = 55, refreshingClosure refreshClosure:@escaping (() -> Swift.Void))

```

## Installation

### From CocoaPods

Add 'pod 'XREasyRefreshControl'' to your Podfile.

## Usage

### Add a drop-down refresh

```swift

mainTableView.xr_addPullToRefreshWithRefreshHeader(refreshHeader: XRCircleAnimatorRefreshHeader(), heightForHeader: 70) {
       
	// do refresh request           
}

```

### Auto dropdown refresh

```swift

mainTableView.xr_beginHeaderRefreshing()

```

### End dropdown refresh

```swift

mainTableView.xr_endHeaderRefreshing()

```


### Add a pull-up load

```swift

self.mainTableView.xr_addPullToLoadingMoreWithRefreshFooter(refreshFooter: XRActivityRefreshFooter(), heightForFooter: 55) {

	// do loading more request
}

```

### End the pull up load more

```swift

mainTableView.xr_endFooterRefreshing()

```

### The end pull-up loads more, showing no more data

```swift

mainTableView.xr_endFooterRefreshingWithNoMoreData()

```

### End the pull up load more, remove the pull up load more controls

```swift

mainTableView.xr_endFooterRefreshingWithRemoveLoadingMoreView()

```

### End the pull up load more, load failed, click reload

```swift

mainTableView.xr_endFooterRefreshingWithLoadingFailure()

```















