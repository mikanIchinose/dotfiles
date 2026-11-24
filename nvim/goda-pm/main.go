package main

import (
	"context"

	"github.com/Shougo/goda-pm-ext-lazy.vim/ext/lazy"
	"github.com/Shougo/goda-pm-ext/ext/installer"
	"github.com/Shougo/goda-pm-ext/ext/protocol/git"
	"github.com/Shougo/goda-pm-ext/ext/toml"
	"github.com/Shougo/goda-pm.vim/pm"
)

func main() {
	b := pm.New()
	b.AddProtocol(git.New())
	b.AddExt(installer.New())
	b.SetConfig(func(ctx context.Context, c *pm.ConfigArgs) (*pm.ConfigReturn, error) {
		t, err := toml.Load(ctx, c.Host, "$BASE_DIR/goda.toml", pm.Plugin{"lazy": false})
		if err != nil {
			return nil, err
		}
		r, err := lazy.MakeState(ctx, c.Host, t.Plugins)
		if err != nil {
			return nil, err
		}
		return &pm.ConfigReturn{Plugins: r.Plugins, StateLines: r.StateLines, Ftplugins: t.Ftplugins}, nil
	})
	b.Main()
}
