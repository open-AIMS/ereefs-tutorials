# List of ideas to possible implement

* Resources section. Linked from the homepage. A collection of things like: 
  - table mapping index `k` to depths for the models (recall python `k` = R `k` - 1 since python starts counting at 0 🤦)
  - ereefs shapefiles (boundary, grid)
  - eatlas reef boundaries shapefile
  - etc.

* Efficient server access (R & Python). The third tutorial in the server access series. Considers ways to maximise efficiency of accessing data from the server (e.g. for 50,000 points). Provide a time comparison of R vs python. (Minimize the number of files opened, Check if points are in the eReefs model scope, Check if multiple points in single model grid cell).

* Map plot tutorial (R & Python) in plotting series. Looks at plotting points and rasters on maps (static and interactive with leaflet).

* Programmatic access tutorial: "probably should talk about the data extraction tool. i.e. help the reader understand when they would want to go to the trouble of writing a script, verses using the extraction tool. This would highlight the strengths and weaknesses of the two approaches."

* Time series plot - fix link: "This data can be downloaded here. !Replace link after upload (so github tutorial link can be added to data page)!"