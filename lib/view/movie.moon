cosmo = require 'cosmo'
ViewNode = require 'view/node'

--- 影片节点视图组件
-- @module view/movie
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewMovie
class ViewMovie extends ViewNode
    --- 是否使用瀑布流式列表布局
    -- @field
    masonry: true

    --- 定制 CSS 块代码
    -- @function css
    -- @return string
    -- @usage html = view:css()
    css: () =>
        [=[
<link href="//cdn.bootcss.com/video.js/5.19.0/video-js.min.css" rel="stylesheet">
<link href="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.css" rel="stylesheet">
]=]

    --- 定制 JS 块代码
    -- @function js
    -- @return string
    -- @usage html = view:js()
    js: () =>
        [=[
<script src="//cdn.bootcss.com/video.js/5.19.0/video.min.js"></script>
<script src="//cdn.bootcss.com/fancybox/3.0.47/jquery.fancybox.min.js"></script>
]=]

    --- 定制页面头部块代码
    -- @function head
    -- @return string
    -- @usage html = view:head()
    head: () =>
        cosmo.fill [=[
<div class="row">
  <div class="col-xs-12 col-md-8 col-md-offset-2">
    <video class="video-js" controls preload="auto" poster="cover.jpg" width="$width" height="$height" data-setup='{"aspectRatio": "$ratio"}' style="margin:0 auto">
      <source src="movie.mp4">
    </video>
    <h2>
      $title
      $if{ $height > 719 }[[
        <span class="label label-success">HD</span>
      ]][[
        <span class="label label-warning">SD</span>
      ]]
    </h2>
  </div>
</div>
]=],
            if: cosmo.cif
            title: @node.name
            width: 720
            height: 404
            ratio: '16:9'

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: () =>
        cosmo.fill [=[
<div class="panel panel-warning">
  $if{ $node|meta|actors }[[
    <div class="panel-heading">
      <ul class="list-inline">
        $yield_actors[[
          <li>
            $if{ $actorset }[[
              <a href="$actorset|uri$name/">
                $name
                $if{ 0 < $age }[[
                  ($age)
                ]]
              </a>
            ]][[
              $name
            ]]
          </li>
        ]]
      </ul>
    </div>
  ]]
  <div class="panel-body">
    <dl class="dl-horizontal">
      $if{ $node|meta|series }[[
        <dt>Series</dt>
        <dd>
          <p>
            $if{ $seriesset }[[
              <a href="$seriesset|uri$node|meta|series/">$node|meta|series</a>
            ]][[
              $node|meta|series
            ]]
          </p>
        </dd>
      ]]
      $yield_meta[[
        <dt>$tag</dt>
        <dd>
          <p>$value</p>
        </dd>
      ]]
      $if{ $node|meta|links }[[
        <dt>References</dt>
        <dd>
          <ul class="list-unstyled">
            $yield_links[[
              <li>
                <a href="$url" target="_blank">$title</a>
              </li>
            ]]
          </ul>
        </dd>
      ]]
    </dl>
  </div>
  <div class="panel-footer text-right text-danger">
  </div>
</div>
$if{ 0 < #$snaps }[[
  <div class="row masonry">
    $snaps[[
      <div class="col-xs-12 col-sm-6 col-md-4 col-lg-3 item">
        <a href="$node|uri$it" data-fancybox="snaps">
          <img class="img-responsive img-thumbnail" src="$node|uri$it">
        </a>
      </div>
    ]]
  </div>
]]
]=],
            if: cosmo.cif
            node: @node
            actorset: @node\actorset!
            yield_actors: () ->
                actors = @node\actorset!
                year = @node\date '%Y'
                for name in *@node.meta.actors
                    age = if actors
                        actor = actors\child name
                        if actor and actor\date '%Y'
                            year - actor\date '%Y'
                        else
                            0
                    else
                        0
                    cosmo.yield :name, :age
            seriesset: @node\seriesset!
            yield_meta: () ->
                for tag, value in pairs @node.meta
                    if 'actors' != tag and 'series' != tag and 'links' != tag
                        cosmo.yield :tag, :value
            yield_links: () ->
                for title, url in pairs @node.meta.links
                    cosmo.yield :title, :url
            snaps: do
                snaps = [ i for i in *@node\assets! ]
                if 0 < #snaps
                    math.randomseed os.time!
                    for one = 1, #snaps
                        another = math.random #snaps + 1 - one
                        snaps[one], snaps[another] = snaps[another], snaps[one]
                snaps
