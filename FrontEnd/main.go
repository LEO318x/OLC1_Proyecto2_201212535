package main

import(
	"fmt"
	"net/http"
	"html/template"
)

func index(w http.ResponseWriter, r *http.Request){
	w.Header().Set("Content-Type", "text/html")
	template, err := template.ParseFiles("pagina/index.html")
	if err != nil{
		fmt.Fprintf(w, "pagina no encontrada")
	}else{
		template.Execute(w,nil)
	}
}

func main(){
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("pagina/css/"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("pagina/js/"))))

	http.HandleFunc("/", index)
	fmt.Println("servidor activo")
	http.ListenAndServe(":8080",nil)
}