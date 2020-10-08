package main

import(
	"fmt"
	"net/http"
	"html/template"
)

func index(w http.ResponseWriter, r *http.Request){
	template, err := template.ParseFiles("pagina/index.html")
	if err != nil{
		fmt.Fprintf(w, "pagina no encontrada")
	}else{
		template.Execute(w,nil)
	}
}

func main(){
	//http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("templates/css/"))))

	http.HandleFunc("/", index)
	fmt.Println("servidor activo")
	http.ListenAndServe(":8080",nil)
}