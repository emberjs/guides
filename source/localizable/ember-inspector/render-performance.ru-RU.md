You can use the Inspector to measure your app's render times. Click on `Render Performance` to start inspecting render times.

<img src="../../images/guides/ember-inspector/render-performance-screenshot.png" width="680" />

### Accuracy

Using the Inspector adds a delay to your rendering, so the durations you see are not an accurate representation of the speed of your production apps. Use these times to compare durations and debug rendering bottlenecks, but not as a way to accurately measure rendering times.

### Toolbar

Click on the "clear" icon to remove existing render logs.

To measure components and templates that are rendered on initial application boot, click on the "Reload" button at the top. This button ensures that the Inspector starts measuring render times when your app boots.

To filter the logs, type a query in the search box.