package main

import (
	"github.com/Shougo/goda-fi.vim/ext/filter/matchersubstring"
	kindfile "github.com/Shougo/goda-fi.vim/ext/kind/file"
	"github.com/Shougo/goda-fi.vim/ext/source/filerec"
	"github.com/Shougo/goda-fi.vim/fi"
	"github.com/Shougo/goda-fi.vim/ui/ff"
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
