lassul.us/site: FORCE
	ghc lassul.us/site.hs
lassul.us/_site: FORCE
	cd lassul.us; ./site clean; ./site build
deploy: lassul.us/_site
	rsync -va --delete lassul.us/_site/ blog@prism:
FORCE:
