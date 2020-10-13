#weboldalak cralwjanak elokeszitese

#1. blogsok cimenek leszedese az xmlekbol
#2. blogok sitemapjanak lecrawlozasa

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
l_mainxml1 <- sum(sapply(mainxml1,length))-1

alxml1 <- NULL #alxml-ek listaja, kiolvassa a mainxml-bol az alxml-eket
for (i in c(1:l_mainxml1)) {alxml1[i]<-as.character(unname(mainxml1$sitemapindex[i]$sitemap$loc[1]))}

#1.2 alxml-kbol a blogcimek kinyerese #forras: alxml1, ami 328 xml

webcmk1 <- data.frame(oldanev=as.character("weboldal https cime"),lastmod="-0001-11-30T00:00:00+0100",changefreq=as.character("yearly"),priority=0.1)

for (i in c(1:l_mainxml1))
	{
	tempxml1<-as_list(read_xml(alxml1[i]))
	l_tempxml1 <- sum(sapply(tempxml1,length))-1

			for(j in c(1:l_tempxml1))
			{
			oldalnev1<-as.character(unname(tempxml1$urlset[j]$url$loc[1]))
			lastmod1<-as.character(unname(tempxml1$urlset[j]$url$lastmod[1]))
			changefreq1<-as.character(unname(tempxml1$urlset[j]$url$changefreq[1]))
			priority1<-as.character(unname(tempxml1$urlset[j]$url$priority[1]))

			cbind(webcmk1, data.frame(oldanev=as.character(oldalnev1),lastmod=lastmod1,changefreq=as.character(changefreq1),priority=as.numeric(priority1)))
			}
	}

#file kiirasa ugyesen
save(webcmk1, file="webcmk1.rmd", compression_level=9, eval.promises = TRUE, precheck = TRUE)


#2. blogok sitemapcsv-jenek leszedese es kiirasa
#oooooooooooooooooooooooooooooooooooooooooooooo
load(file="webcmk1.rmd")
l_wbcmk1 <- length(webcmk1)

sitemap1 <- data.frame(pages=as.character("oldalnev"), status=as.character("http_status"), lekerve=as.character("lekeres_datuma"))

for (i in c(1:l_wbcmk1)) #vegigfutunk a webblogcimeken
{
	Rcrawler(Website = webcmk1[i], no_cores = 1, no_conn = 1, Obeyrobots = TRUE) #user keresenek megfeleloen engedelmeskedunk a robotoknak
	pages <- LinkExtractor(url = unname(as.character(webcmk1[i,1])), ExternalLInks=FALSE) #belso linkek kigyujtese
  #ideiglenes sitemap osszeallitasa
	sitemapt <- data.frame(pages=pages$InternalLinks, status=NA, lekerve=NA )
	#sitemapon vegigmegy es lekeri a http statust
	#for(i in 1:dim(sitemapcsv)[1])
	#	{
	#	sitemapcsv[i,2]<-http_status(GET(as.character(sitemapcsv[i,1])))$message
	#	sitemapcsv[i,3]<-Sys.time()
	#	}

	cbind(sitemap1,sitemapt) #a nagy sitemaphoz a leszedett sitemap hosszafuzese
}
save(sitemap1, file="sitemap1.rmd", compression_level=9, eval.promises = TRUE, precheck = TRUE)
