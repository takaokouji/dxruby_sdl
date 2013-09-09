# -*- coding: utf-8 -*-

# spec/fixturesに配置しているファイルの絶対パスを返す
#
# @param [String] filename ファイル名
def fixture_path(filename)
  return File.expand_path("../../fixtures/#{filename}", __FILE__)
end
