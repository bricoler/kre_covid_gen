#Adatelkeszites, adatleszedes -- blog.hu leszedese
#1. blogsok cimenek leszedese
#2. blogok sitemap felepitese

#blog.hu website crawler
#install.packages("rvest")
#install.packages("xml2")
#install.packages("Rcrawler")
#install.packages("httr")
#install.packages("xml2")

system("java -version")
library("xml2")
library("Rcrawler")
library("rvest")
library("httr")
library(xml2)

#1.xml-bol a blogcimek leszedese es tarolasa
#oooooooooooooooooooooooooooooooooooooooooooooo

#1.1 mainxml-bol alxml-ek leszedese es tarolasa
mainxml1 <- as_list(read_xml("https://blog.hu/blogs.xml")) #xml ami az xml-ket tartalmazza

alxml1 <- NULL #alxml-ek listaja
for (i in c(1:328)) {alxml1[i]<-as.character(unname(mainxml1$sitemapindex[1]$sitemap$loc[1]))}

#1.2 alxml-kbol a blogcimek kinyerese #forras: alxml1, ami 328 xml

webcmk1 <- data.frame(oldanev=as.character("weboldal https cime"),lastmod="-0001-11-30T00:00:00+0100",changefreq=as.character("yearly"),priority=0.2)

for (i in c(1:328))
{
tempxml1<-as_list(read_xml(alxml1[i]))
webcmk1$oldalnev[i]<-
webcmk1$oldalnev[i]<-
}


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
