#Adatelkeszites, adatleszedes -- blog.hu leszedese
#1. blogsok cimenek leszedese
#2. blogok sitemap felepitese

#blog.hu website crawler
install.packages("rvest")
install.packages("xml2")
install.packages("Rcrawler")
install.packages("httr")

system("java -version")
library("xml2")
library("Rcrawler")
library("rvest")
library("httr")


#1.xml-bol a blogcimek leszedese es tarolasa
#oooooooooooooooooooooooooooooooooooooooooooooo
#<url>
#<loc>https://szentendreikozugyek.blog.hu/</loc>
#<lastmod>-0001-11-30T00:00:00+0100</lastmod>
#<changefreq>yearly</changefreq>
#<priority>0.2</priority>
#</url>

blgld <- NULL #blogoldalakat nyilvantarto data.frame
blgld <- data.frame(oldanev=as.character("https://szentendreikozugyek.blog.hu/"),lastmod="-0001-11-30T00:00:00+0100",changefreq=as.character("yearly"),priority=0.2)
#oooooooooooooooooooooooooooooooooooooooooooooo

#egy blog sitemapjanak leszedese, forrasadat:blgld
#oooooooooooooooooooooooooooooooooooooooooooooo

Rcrawler(Website = blgld[1], no_cores = 1, no_conn = 1, Obeyrobots = TRUE) #user keresenek megfeleloen engedelmeskedunk a robotoknak
pages <- LinkExtractor(url = unname(as.character(blgld[1,1])), ExternalLInks=FALSE) #belso linkek kigyujtese

sitemapcsv <- data.frame(pages=pages$InternalLinks, status=NA, lekerve=NA )  #sitemap osszeallitasa

#sitemapon vegigmegy es lekeri a http statust
for(i in 1:dim(sitemapcsv)[1])
	{
	sitemapcsv[i,2]<-http_status(GET(as.character(sitemapcsv[i,1])))$message
	sitemapcsv[i,3]<-Sys.time()
	}

View(sitemapcsv)
