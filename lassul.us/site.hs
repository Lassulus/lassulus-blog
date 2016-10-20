--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
--------------------------------------------------------------------------------

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "stuff"
    , feedDescription = "This feed provides"
    , feedAuthorName  = "lassulus"
    , feedAuthorEmail = "feed@lassul.us"
    , feedRoot        = "http://lassul.us"
    }



--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do

    match "art/portraits/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "art/stuff/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "icons/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.markdown", "art.markdown", "projects.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    defaultContext
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- loadAll "posts/*"
            let archiveCtx =
                    listField "posts" defaultContext (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- loadAll "posts/*"
            let indexCtx =
                    listField "posts" defaultContext (return posts) `mappend`
                    constField "title" "/"                   `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

    create ["atom.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = postCtx `mappend`
                constField "description" ""

        posts <- loadAll "posts/*"
        renderAtom feedConfiguration feedCtx posts

    create ["rss.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = postCtx `mappend`
                constField "description" ""

        posts <- loadAll "posts/*"
        renderRss feedConfiguration feedCtx posts

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    constField "published" "%B %e, %Y" `mappend`
    constField "updated" "%B %e, %Y" `mappend`
    defaultContext
