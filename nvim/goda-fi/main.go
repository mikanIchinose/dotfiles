package main

import (
	"github.com/Shougo/goda-fi-ext/ext/filter/matchersubstring"
	kindfile "github.com/Shougo/goda-fi-ext/ext/kind/file"
	"github.com/Shougo/goda-fi-ext/ext/source/filerec"
	"github.com/Shougo/goda-fi-ui-ff.vim/ui/ff"
	"github.com/Shougo/goda-fi.vim/fi"
)

func main() {
	b := fi.New()
	b.AddUI(ff.New())
	b.AddSource(filerec.New(filerec.Params{}))
	b.AddFilter(matchersubstring.New(matchersubstring.Params{}))
	b.AddKind(kindfile.New())
	b.PatchGlobal(fi.Options{
		UI: "ff",
		SourceOptions: map[string]fi.SourceOptions{
			"_": {Matchers: []string{"matchersubstring"}},
		},
		KindOptions: map[string]fi.KindOptions{
			"file": {DefaultAction: "open"},
		},
	})
	b.Main()
}
