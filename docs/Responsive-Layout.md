Scenario: Make the application look good, no matter which device is used.

Description: In the beginning most of our use were using desktop browsers, but recently we've been seeing more and more usage of mobile browsers in our analytics, so we'd like to make sure our application looks good in them. We also have a few visual bugs that had been pushed down in priority over the past few sprints that we want to finally address.

The desktop layout inconsistencies and mobile phone portrait orientation are the most important focus for this scenario, but if we are also able to make tablet portrait look good (and not just a blown up mobile portrait) that would be even better.

Some elements are loaded asynchronously and may be slow, so we'd also optionally like to have either loading spinners or skeleton layouts for those portions.

Here are the suggested mobile layouts by our designer. Note that we are not really going for a pixel-perfect implementation; we know that graphic design cannot always depict actual browser interactions, so we'd like you to use your best judgment in case you want to make adjustments.

Major elements to focus on for mobile layout as per provided designs: 

1. Mobile Navbar
	- The navigation bar doesn't fit well in the mobile view, so adding a hamburger menu is necessary. the menu will contain all of the current nabvbar items in list form.
2. Align URL shortening form
	- The shorten URL form elements' margin and padding needs to be adjusted.
3. Remove Link Image
	- Link image is not required for mobile layout. So, it needs to be removed.
4. Adjust the middle section (containing brand images)
	- The container with brand images is not showing all the brand logos on mobile layout. It needs to be fixed as per the design.
5. Adjust the bottom section
	- The descriptive section for homepage(Shorten, Track and Learn) needs to be aligned properly as per the design
6. Adjust Most Visited and Most Recent Links
	- Here the Box that's containing the links should be adjusted as per the design to fit the links
7. Analytics Page
	- For the analytics page, we have future plans on adding the realtime graphs and the geoip maps. For now it can be replaced either with placeholders, or they can be omitted entirely.
	- Adjust styles of elements to match with the design

The home page layout on mobile is envisioned to be a single column, block-based design with the header having a hamburger menu that expands and contracts on activation:

![](images/mobile-not-logged-in-menu-open.png)  |  ![](images/mobile-not-logged-in-menu-closed.png)

The header layout changes when a user is logged in, so we'd like to get that working and designed as well:

![](images/mobile-logged-in-avatar-menu-open.png)  |  ![](images/mobile-logged-in-avatar-menu-closed.png)

For the analytics page, we have future plans on adding the realtime graphs and the geoip maps. For now it can be replaced either with placeholders, or they can be omitted entirely.

We'd like to maintain parity with the desktop version regarding navigation behavior, so if a link goes to a different page or opens in a new window or tab, it should keep the same

![](images/mobile-analytics.png)
