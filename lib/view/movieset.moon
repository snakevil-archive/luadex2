cosmo = require 'cosmo'
ViewNode = require 'view/node'

--- 影片索引节点视图组件
-- @module view/movieset
-- @author Snakevil Zen <zsnakevil@gmail.com>
-- @copyright 2017 SZen.in
-- @license GPL-3.0+
-- @class ViewMovieSet
class ViewMovieSet extends ViewNode
    --- 是否使用瀑布流式列表布局
    -- @field
    masonry: true

    --- 定制 CSS 块代码
    -- @function css
    -- @return string
    -- @usage html = view:css()
    css: =>
        [=[
<style>
.thumbnail {
  background-position: right;
  background-size: auto 100%;
}
.thumbnail img {
  visibility: hidden;
  margin-top: 80%;
}
</style>
]=]\gsub('\n%s*', '')\gsub('([:,])%s+', '%1')\gsub '%s*%{', '{'

    --- 定制页面内容块代码
    -- @function body
    -- @return string
    -- @usage html = view:body()
    body: =>
        cosmo.fill [=[
$cond_movies[[
  $yield_years[[
    <h2>$year</h2>
    <div class="row masonry">
      $movies[[
        <div class="col-xs-6 col-sm-4 col-lg-3 item">
          <a class="thumbnail" href="$uri" style="background-image:url($uri./cover.jpg)">
            <img src="$uri./cover.jpg">
          </a>
        </div>
      ]]
    </div>
  ]]
]]
]=],
            cond_movies: do
                movies = @node\children!
                cosmo.cond 0 < #movies,
                    yield_years: ->
                        years = {}
                        ymovies = {}
                        for movie in *movies
                            year = os.date '%Y', movie.meta.date
                            if not ymovies[year]
                                table.insert years, year
                                ymovies[year] = {}
                            table.insert ymovies[year], movie
                        table.sort years, (one, another) ->
                            one > another
                        for year in *years
                            cosmo.yield
                                :year
                                movies: ymovies[year]
