
LIBS = lablgtk.cma gtkInit.cmo
# CUSTOM = -custom

CAML_FLAGS = $(CUSTOM) -warn-error A -I +lablgtk2

SRCS = \
	base.ml \
	hello.ml \
	hello2.ml \
	packbox.ml \
	table.ml \
	button.ml \
	radiobutton.ml \
	range.ml \
	label.ml \
	arrow.ml \
	progressbar.ml \
	ruler.ml \
	statusbar.ml \
	entry.ml \
	spinbutton.ml \
	calendar.ml \
	colorsel.ml \
	filesel.ml \
	event_box.ml \
	fixed.ml \
	frame.ml \
	aspectframe.ml \
	paned.ml \
	scrolledwin.ml \
	buttonbox.ml \
	toolbar.ml \
	notebook.ml \
	menu_entry.ml \
	clipboard.ml \
	scribble.ml

TARGETS = $(SRCS:.ml=.exe)

all: $(TARGETS)

clean:
	rm -rf *.cmi *.cmo *.cmx *.o *.obj *.exe *~

tar:
	(cd ..; tar cvf - lablgtk2_tutorial_src | gzip -c > lablgtk2_tutorial_src.tar.gz)

install:
	cp ../lablgtk2_tutorial_src.tar.gz $(HOME)/www/ocaml/lablgtk2

.SUFFIXES: .ml .cmo .cmx .exe

.ml.cmo:
	ocamlc -c $(CAML_FLAGS) $<

.ml.exe:
	ocamlc $(CAML_FLAGS) -o $@ $(LIBS) $<

.ml.cmx:
	ocamlopt -c $(CAML_FLAGS) $<
