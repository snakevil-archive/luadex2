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

    --- 定制页面内容块代码
    -- @function body
    -- @int[opt] birthday
    -- @return string
    -- @usage html = view:body()
    body: (birthday) =>
        cosmo.fill [=[
$cond_movies[[
  $yield_years[[
    <h2>
      $year
      $if{ $age }[[
        <span class="small">$age</span>
      ]]
    </h2>
    <div class="row _list">
      $movies[[
        <div class="col-xs-6 col-sm-4 col-lg-3 _item">
          <a class="thumbnail" href="$uri" style="background-image:url($uri./cover.jpg)">
            <img src="$uri./cover.jpg">
          </a>
        </div>
      ]]
    </div>
  ]]
]]
]=],
            if: cosmo.cif
            cond_movies: do
                movies = @node\children!
                cosmo.cond 0 < #movies,
                    yield_years: ->
                        years = {}
                        ymovies = {}
                        born = if birthday
                            os.date '%Y', birthday
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
                                age: if born
                                    '/' .. (year - born) .. 'y'
                                movies: ymovies[year]
