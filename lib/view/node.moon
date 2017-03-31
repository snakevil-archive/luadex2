cosmo = require 'cosmo'

--- 基础节点视图组件
-- @module view/node
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewNode
class ViewNode
    --- 节点实例
    -- @field
    node: nil

    --- 是否使用瀑布流式列表布局
    -- @field
    masonry: false

    --- 构造函数
    -- @param ModelNode node
    new: ( node ) =>
        @node = node

    --- 定制页面标题
    -- @function title
    -- @return string
    -- @usage title = view:title()
    title: () =>
        @node.name

    --- 定制 CSS 块代码
    -- @function css
    -- @return string
    -- @usage html = view:css()
    css: () =>
        ''

    --- 定制 JS 块代码
    -- @function js
    -- @return string
    -- @usage html = view:js()
    js: () =>
        ''

    --- 定制页面头部块代码
    -- @function head
    -- @return string
    -- @usage html = view:head()
    head: () =>
        "<h1>#{@node.name}</h1>"

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: () =>
        cosmo.fill [=[
<div class="panel panel-info">
  <div class="panel-body">
    <div class="table-responsive">
      <table class="table table-hover">
        $if{ 0 < #$folders }[[
          <tbody>
            $folders[[
              <tr>
                <td>
                  <a href="$uri">$name</a>
                </td>
              </tr>
            ]]
          </tbody>
        ]]
        $if{ 0 < #$files }[[
          <tbody>
            $files[[
              <tr>
                <td>
                  <a href="$prefix$it">$it</a>
                </td>
              </tr>
            ]]
          </tbody>
        ]]
      </table>
    </div>
  </div>
</div>
]=],
            if: cosmo.cif
            folders: @node\children!
            files: @node\assets!
            prefix: @node.uri

    --- 渲染
    -- @function render
    -- @return string
    -- @usage html = view:render()
    render: () =>
        cosmo.fill [=[
<!doctype html>
<html class="no-js" lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <title>$title - Luadex</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
  $css
</head>
<body>
  <div class="jumbotron">
    <div class="container">
      <ol class="breadcrumb">
        $nav[[
          <li><a href="$uri">$name</a></li>
        ]]
      </ol>
      $head
    </div>
  </div>
  <div class="container">
    $body
  </div>
  <div class="jumbotron" style="margin-bottom:0">
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-8 col-sm-offset-4">
          <address>
            <strong>
              <a href="https://github.com/snakevil/luadex" target="_blank">Luadex</a>
              <span>, A piece of expirement work of&nbsp;</span>
              <a href="https://twitter.com/snakevil" target="_blank">@Snakevil</a>
            </strong>
            <br>
            <span>Based on&nbsp;</span>
            <a href="https://github.com/openresty/lua-nginx-module/" target="_blank">ngx_lua</a>
            <span>,&nbsp;</span>
            <a href="http://keplerproject.github.io/luafilesystem/" target="_blank">LuaFileSystem</a>
            <span>,&nbsp;</span>
            <a href="https://github.com/gvvaughan/lyaml" target="_blank">LYAML</a>
            <span>&nbsp;and&nbsp;<span>
            <a href="http://cosmo.luaforge.net" target="_blank">Cosmo</a>
            <br>
            <span>Rendered with&nbsp;<span>
            <a href="http://getbootstrap.com" target="_blank">Bootstrap</a>
            <span>,&nbsp;</span>
            <a href="http://jquery.com" target="_blank">jQuery</a>
            <span>,&nbsp;</span>
            <a href="http://videojs.com" target="_blank">Video.js</a>
            <span>,&nbsp;</span>
            <a href="http://masonry.desandro.com" target="_blank">Masonry</a>
            <span>&nbsp;and&nbsp;<span>
            <a href="http://fancyapps.com/fancybox/3/" target="_blank">fancyBox</a>
            <br>
            <em>
              <span>Thanks to&nbsp;</span>
              <a href="http://www.bootcdn.cn" target="_blank">BootCDN</a>
              <span>&nbsp;for their free service :-)</span>
            </em>
          </address>
        </div>
      </div>
    </div>
  </div>
  <script src="//cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
  <script src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  $js
</body>
</html>
]=],
            title: @title!
            css: @css! .. if @masonry
                '<style>.masonry .item{margin-bottom:15px}</style>'
            else
                ''
            js: @js! .. if @masonry
                [=[
<script src="//cdn.bootcss.com/masonry/4.1.1/masonry.pkgd.min.js"></script>
<script>
(function(m,n,i,j,k){
  i=$(m+' '+n+' img'),
  j=0,
  k=function(){
    if(i.length==++j)
      $(m).masonry({
        itemSelector:n
      });
  };
  i.each(function(_){
    _=this;
    _.complete
      ?k()
      :_.onload=k;
  });
})('.masonry','.item');
</script>
]=]\gsub '\n%s*', ''
            else
                ''
            head: @head!
            body: @body!
            nav: do
                items = {
                    {
                        uri: '/'
                        name: 'Home'
                    }
                }
                last = ''
                parent = @node\parent!
                while parent
                    last = parent.uri
                    table.insert items, parent if '/' != last
                    parent = parent\parent!
                if '/' != last
                    uri = '/'
                    for name in last\gmatch '[^/+]'
                        uri ..= name .. '/'
                        table.insert items, :uri, :name if uri != last
                table.sort items, ( one, another ) ->
                    #one.uri < #another.uri
                items