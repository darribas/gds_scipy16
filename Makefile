notebooks:
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/02_data_processing.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/03_esda.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/04_spatial_clustering.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/05_spatial_regression.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/06_points.ipynb
	zip -r gds_scipy16.zip content
website:
	gitbook pdf ./ ./gds_scipy16.pdf
	gitbook epub ./ ./gds_scipy16.epub
	gitbook mobi ./ ./gds_scipy16.mobi
	gitbook build
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

