package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterlength"
	"github.com/Shougo/goda-cmp.vim/ext/source/around"
	"github.com/Shougo/goda-cmp.vim/ext/ui/native"
)

func main() {
	b := cmp.New()
	b.AddUI(native.New())
	b.AddSource(around.New(around.Params{MinLength: 2}))
	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(sorterlength.New())
	b.PatchGlobal(cmp.Config{
		UI:      "native",
		Sources: []string{"around"},
		SourceOptions: map[string]cmp.SourceOption{
			"_":      {Matchers: []string{"matcherhead"}, Sorters: []string{"sorterlength"}},
			"around": {Mark: "A"},
		},
	})
	b.Main()
}
