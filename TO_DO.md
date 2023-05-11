# List of ideas to possible implement

* Resources section. Linked from the homepage. A collection of things like: 
  - table mapping index `k` to depths for the models (recall python `k` = R `k` - 1 since python starts counting at 0 🤦)
  - eReefs shapefiles (boundary, grid)
  - eAtlas reef boundaries shapefile
  - etc.

* Efficient server access (R & Python). The third tutorial in the server access series. Considers ways to maximize efficiency of accessing data from the server (e.g. for 50,000 points). Provide a time comparison of R vs python. (Minimize the number of files opened, Check if points are in the eReefs model scope, Check if multiple points in single model grid cell).

* Map plot tutorial (R & Python) in plotting series. Looks at plotting points and rasters on maps (static and interactive with leaflet).

* Intro tut. --- work to do: 
  - Source images (incl. icons in fig 1)
  - Add in more about model validation?
  - Add in more about model accuracy! Incl. a mini-review of studies assessing this. 
  - Curvilinear vs linear grids
  - Continue working on model variable lists 


* General to do: 
  - Change tutorial series banner 
  - Better description of BGC scenarios
  - Link back to the aims ereefs website from navbar