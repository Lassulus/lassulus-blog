lassul.us/site:
	ghc lassul.us/site.hs
lassul.us/_site:
	cd lassul.us; ./site build
deploy:
	rsync -va --delete lassul.us/_site/ blog@prism:
