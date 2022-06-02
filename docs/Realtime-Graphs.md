Scenario: Generate realtime graphs of visits to shortened links.

Description: On the analytics page of each shortened link, we'd like to have a small graph that will track in realtime the clicks on a shortened link over time.

One example of a shortened link is http://localhost:3000/a/hk (assuming you've already started the development server).

Right now the visits themselves are tracked in realtime (you can try this by clicking on a shortened link while having the analytics page for that link open in a separate window) but this would only track the cumulative number of visits; we'd also like to track the number of visits every 5 seconds as a bar graph.

The x-axis of this graph will be time (in 1 minute intervals) while the y-axis will be the number of visits for the link.

For now we'll settle for having only a fixed 1 minute interval, but it would be great if we have the option to change the interval from 5 seconds, to 1 minute, to 30 minute intervals. This is just a stretch goal though.
