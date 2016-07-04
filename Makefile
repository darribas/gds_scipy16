notebooks:
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/01_data_processing.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/02_geovisualization.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/03_spatial_weights.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/04_esda.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/05_spatial_dynamics.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/06_points.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/07_spatial_clustering.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/08_spatial_regression.ipynb
	rm -fr content/part1/.ipynb_checkpoints/
	rm -fr content/part2/.ipynb_checkpoints/
	zip -r gds_scipy16.zip content
website:
	#gitbook pdf ./ ./gds_scipy16.pdf
	#gitbook epub ./ ./gds_scipy16.epub
	#gitbook mobi ./ ./gds_scipy16.mobi
	gitbook build
	#git add gds_scipy16.pdf gds_scipy16.mobi
	#git commit -m "Pre website build output compilation"
	git checkout gh-pages
	cp -r _book/* ./
	git add .
	git commit -am "Building website"
	git push origin gh-pages
	git checkout master
book:
	gitbook pdf ./ ./gds_scipy16.pdf
	gitbook epub ./ ./gds_scipy16.epub
	gitbook mobi ./ ./gds_scipy16.mobi

