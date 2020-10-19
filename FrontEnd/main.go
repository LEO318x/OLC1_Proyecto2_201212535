package main

import(
	"fmt"
	"net/http"
	"html/template"
	"encoding/json"
	"log"
	"io/ioutil"
	"bytes"
	//"os"
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

func getDataJS(w http.ResponseWriter, r *http.Request){
	//Cabecera
	w.Header().Set("Content-Type", "application/json")
	//Obtenemos la información que nos envía el navegador a través de Ajax	
	r.ParseForm()
	datos := r.Form.Get("data")

	//Creamos una estructura que nos servira luego para realizar la petición go <-> nodejs
	type query struct { 
		Data string  `json:"data"` 
   	}
	
	datajson := query {Data: datos} //Agregamos los datos
	
	datosEnviar, err := json.Marshal(datajson) //Convertimos a json
	if err != nil {
		log.Println(err)
	}
	
	//URL para realizar la petición a nodejs
	url := "http://localhost:3000/traducirjs"

	//Realizamos la petición a nodejs a través de post
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(datosEnviar))
	if err != nil {
		log.Fatalln(err)
	}

	defer resp.Body.Close() //Cerramos la conexión de la petición ya que ya no será utilizada de nuevo.
	body, err := ioutil.ReadAll(resp.Body) //Leemos la respuesta que nos dio nodejs

	if err != nil {
		log.Fatalln(err)
	}

	fmt.Fprintf(w, string(body)) //Mostramos la respuesta de la petición
}

func main(){
	puerto := "8080"
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("pagina/css/"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("pagina/js/"))))

	http.HandleFunc("/", index)
	http.HandleFunc("/traducirjs", getDataJS) //Ruta que nos sirve para realizar la petición entre go y nodejs

	fmt.Println("Servidor Go corriendo en puerto "+puerto)
	http.ListenAndServe(":"+puerto,nil)
}

