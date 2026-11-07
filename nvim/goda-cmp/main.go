package main

import (
	"github.com/Shougo/goda-cmp.vim/cmp"
	"github.com/Shougo/goda-cmp.vim/ext/filter/matcherhead"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sorterlength"
	"github.com/Shougo/goda-cmp.vim/ext/filter/sortertext"
	"github.com/Shougo/goda-cmp.vim/ext/source/around"
	"github.com/Shougo/goda-cmp.vim/ext/source/lsp"
	"github.com/Shougo/goda-cmp.vim/ext/ui/native"
)

func main() {
	b := cmp.New()
	b.AddUI(native.New())
	b.AddSource(around.New(around.Params{MinLength: 2}))
	b.AddFilter(matcherhead.New(matcherhead.Params{}))
	b.AddFilter(sorterlength.New())
	// LSP の補完。goda-cmp が gopls を自分で起動する（nvim の vim.lsp の gopls とは別プロセス）
	b.AddSource(lsp.New(lsp.Params{
		Name:        "gopls",
		Command:     []string{"gopls"},
		Filetypes:   []string{"go", "gomod"},
		RootMarkers: []string{"go.work", "go.mod", ".git"},
	}))
	b.AddFilter(sortertext.New())
	b.PatchGlobal(cmp.Config{
		UI:      "native",
		Sources: []string{"around"},
		SourceOptions: map[string]cmp.SourceOption{
			"_":      {Matchers: []string{"matcherhead"}, Sorters: []string{"sorterlength"}},
			"around": {Mark: "A"},
		},
	})
	b.PatchFiletypes([]string{"go", "gomod"}, cmp.Config{
		Sources: []string{"gopls", "around"},
		SourceOptions: map[string]cmp.SourceOption{
			"gopls": {
				Mark:                   "LSP",
				ForceCompletionPattern: `\.\w*`,    // "." の直後は1文字目から補完する
				Matchers:               []string{}, // gopls の絞り込みと並びをそのまま使う
				Sorters:                []string{"sortertext"},
			},
		},
	})
	b.Main()
}
