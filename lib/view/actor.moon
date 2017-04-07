cosmo = require 'cosmo'
ViewMovieSet = require 'view/movieset'

--- 演员节点视图组件
-- @module view/actor
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewActor
class ViewActor extends ViewMovieSet
    --- 定制页面头部块代码
    -- @function head
    -- @return string
    -- @usage html = view:head()
    head: =>
        name = if @node.aliases
            @node.aliases[1]
        else
            @node.name
        cosmo.fill [=[
<div class="row">
  <div class="col-xs-12 col-md-6 col-md-offset-3">
    <div class="media">
      <div class="media-left">
        <img class="media-object img-rounded" src="$node|uri./portrait.jpg">
      </div>
      <div class="media-body">
        <h1 class="media-heading">$name</h1>
        <p>
          $node|meta|romaji
          $if{ $age }[[
            <br>$age
          ]]
        </p>
      </div>
    </div>
  </div>
</div>
]=]
            if: cosmo.cif
            :name
            node: @node
            age: if @node.meta.birthday
                @node\age! .. 'y'

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: =>
        cosmo.fill [=[
<div class="panel panel-warning">
  <div class="panel-heading">
    $if{ $node|meta|aliases }[[
      <ul class="list-inline">
        $node|meta|aliases[[
          <li>$it</li>
        ]]
      </ul>
    ]][[
      &nbsp;
    ]]
  </div>
  <div class="panel-body">
    <dl class="dl-horizontal">
      $if{ $node|meta|size }[[
        <dt>Size</dt>
        <dd>
          <ul class="list-unstyled">
            <li>
              <abbr title="Bust">B</abbr>
              &nbsp;$node|meta|size|B cm
            </li>
            <li>
              <abbr title="Waist">W</abbr>
              &nbsp;$node|meta|size|W cm
            </li>
            </li>
              <abbr title="Hip">H</abbr>
              &nbsp;$node|meta|size|H cm
            </li>
          </ul>
        </dd>
        <dt>Tall</dt>
        <dd>
          <p>$node|meta|size|T cm</p>
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
</div>
$list
]=]
            if: cosmo.cif
            node: @node
            yield_meta: ->
                for tag, value in pairs @node.meta
                    continue if 'romaji' == tag or 'aliases' == tag or 'size' == tag or 'links' == tag
                    value = os.date '%F', value if 'birthday' == tag
                    cosmo.yield
                        tag: tag\sub(1, 1)\upper! .. tag\sub(2)
                        :value
            yield_links: ->
                for title, url in pairs @node.meta.links
                    cosmo.yield :title, :url
            list: super @node.meta.birthday
