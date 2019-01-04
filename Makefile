reset: remove-examples copy-templates

remove-examples:
	rm talk_examples/*.rb

copy-templates:
	cp templates/*.rb talk_examples/
