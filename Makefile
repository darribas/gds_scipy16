notebooks:
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/02_data_processing.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part1/03_esda.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/04_spatial_clustering.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/05_spatial_regression.ipynb
	jupyter nbconvert --to markdown --output-dir ipynb_md/ content/part2/06_points.ipynb
book:
	gitbook pdf ./ ./gds_scipy16.pdf
	gitbook epub ./ ./gds_scipy16.epub
	gitbook mobi ./ ./gds_scipy16.mobi

