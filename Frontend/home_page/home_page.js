function make_icon(id) {
  const NS = "http://www.w3.org/2000/svg";
  const svg = document.createElementNS(NS, "svg");
  svg.classList.add("icon");
  const use = document.createElementNS(NS, "use");
  use.setAttribute("href", "#" + id);
  svg.appendChild(use);
  return svg;
}

let list_location = document.getElementById("location_select");
let list_category = document.getElementById("category_select");
  async function charge_categories() {
      let response = await fetch("http://127.0.0.1:8000/api/categories_HomePage");
      if(response.ok){
          const data= await response.json();
          console.log(data);
          for(const i of data.categories){
              let element=document.createElement("option");
              element.textContent=i.name;
              element.value=i.id;
              list_category.appendChild(element);
          }
      }
      else{
        alert("Error");
      }
    }
  charge_categories();
  async function charge_locations() {
      let response = await fetch("http://127.0.0.1:8000/api/locations_HomePage");
      if(response.ok){
          const data_locations = await response.json();
          console.log(data_locations);
          for(const i of data_locations.locations){
              let location = document.createElement("option");
              location.textContent = i.country;
              location.value=i.id_country;
              list_location.appendChild(location);
          }
      }
      else{
        alert("Error");
      }
  }
  let bull_tot_jobs=document.getElementById("tot_jobs");
  charge_locations();
  async function tot_jobs(){
      let response = await fetch("http://127.0.0.1:8000/api/tot_jobs");
      if(response.ok){
        const tot_jobs = await response.json();
        console.log(tot_jobs);
        bull_tot_jobs.textContent = tot_jobs.tot_jobs;   
      }
      else{
        alert("Error");
      }
  }
  tot_jobs();
  let list_job_title = document.getElementById("job_title_select");
  async function charge_job_titles(){
      let response = await fetch("http://127.0.0.1:8000/api/job_titles");
      if(response.ok){
        const title_jobs = await response.json();
        console.log(title_jobs);
        for(const i of title_jobs.job_titles){
            let element = document.createElement("option")
            element.textContent = i.title;
            element.value= i.id;
            list_job_title.appendChild(element);
        }

      }
      else{
        alert("Error");
      }
  } 
  charge_job_titles();

  let num_tot_comapanies=document.getElementById("tot_companies");
  async function charge_tot_comapnies(){
    let response  = await fetch("http://127.0.0.1:8000/api/tot_companies");
    if(response.ok){
      const tot_companies = await response.json();
      console.log(tot_companies);
      num_tot_comapanies.textContent = tot_companies.tot_companies;
    }
    else{
      alert("Error");
    }
  }
  charge_tot_comapnies();

  let recent_jobs = document.getElementById("recent_jobs");
  async function get_closest_added_jobs(){
      let response = await fetch("http://127.0.0.1:8000/api/recent_jobs");
      if(response.ok){
        const recent_jobs = await response.json();
        console.log(recent_jobs);
        const section = document.getElementById("recent_jobs");
        const div_header = document.createElement("div");
        div_header.classList.add("results_header");
        const title = document.createElement("h2");
        title.textContent = "Recent Jobs Available";
        const a_html = document.createElement("a");
        a_html.setAttribute("href","../Jobs/jobs.html");
        a_html.textContent = "View All";
        div_header.appendChild(title);
        div_header.appendChild(a_html);
        section.appendChild(div_header);
        for(const i of recent_jobs.cards_data){
            const art=document.createElement("article");
            art.classList.add("job_card");
            const div=document.createElement("div");
            div.classList.add("card_top");
            const span=document.createElement("span");
            span.classList.add("time_tag");
            const added_time=new Date(i.added_time);
            const now=new Date();
            let diff=now - added_time;
            if(diff<1000 && diff>=0){
              span.textContent = "Just now";
            }
            else if(diff>=1000 && diff<60000){
              diff = Math.floor(diff/1000);
              span.textContent=`${diff} s ago`;
            }
            else if(diff>=60000 && diff<3600000){
              diff=Math.floor(diff/60000);
              span.textContent=`${diff} min(s) ago`;
            }
            else if(diff>=3600000 && diff<86400000){
              diff=Math.floor(diff/3600000);
              span.textContent=`${diff} hour(s) ago`;
            }
            else if(diff>=86400000 && diff<2592000000){
              diff=Math.floor(diff/86400000);
              span.textContent = `${diff} day(s) ago`;
            }
            else if(diff>=2592000000 && diff<31536000000){
              diff=Math.floor(diff/2592000000);
              span.textContent = `${diff} Month(s) ago`;
            }
            else{
              diff=Math.floor(diff/31536000000);
              span.textContent = `${diff} year(s) ago`;
            }

            
            const btn=document.createElement("button");
            btn.classList.add("bookmark");
            btn.setAttribute("aria-label","Save job");
            btn.setAttribute("aria-pressed","false");
            btn.appendChild(make_icon("icon-bookmark"));
            btn.addEventListener("click", () => {
              btn.setAttribute("aria-pressed", btn.getAttribute("aria-pressed") !== "true");
            });
            div.appendChild(span);
            div.appendChild(btn);
            art.appendChild(div);
            const job_title = document.createElement("h3");
            job_title.textContent=i.title;
            art.appendChild(job_title);
            const name_company = document.createElement("p");
            name_company.classList.add("company");
            name_company.textContent = i.company;
            art.appendChild(name_company);
            const card_btm = document.createElement("div");
            card_btm.classList.add("card_bottom");
            const job_infos = document.createElement("ul");
            job_infos.classList.add("job_info");
            const job_infos_items = document.createElement("li");
            job_infos_items.appendChild(make_icon("icon-briefcase"));
            job_infos_items.append(i.category);
            job_infos.appendChild(job_infos_items);
            const list_items = document.createElement("li");
            list_items.appendChild(make_icon("icon-clock"));
            list_items.append(i.job_type);
            job_infos.appendChild(list_items);
            const list_wallet = document.createElement("li");
            list_wallet.appendChild(make_icon("icon-wallet"));
            list_wallet.append(`${i.min_salary}-${i.max_salary}`);
            job_infos.appendChild(list_wallet);
            const li_location = document.createElement("li");
            li_location.appendChild(make_icon("icon-pin"));
            li_location.append(`${i.country}, ${i.city}`);
            job_infos.appendChild(li_location);
            card_btm.appendChild(job_infos);
            const a_btn = document.createElement("a");
            a_btn.setAttribute("href","");
            a_btn.classList.add("btn");
            a_btn.textContent = "Job Details";
            card_btm.appendChild(a_btn);
            art.appendChild(card_btm);
            section.appendChild(art);
        }
      }
      else{
        alert("Error");
      }
  }
  get_closest_added_jobs();

// Header fica preto ao rolar, senão o menu branco some sobre a lista de vagas
const header = document.querySelector('header');
window.addEventListener('scroll', () => header.classList.toggle('scrolled', scrollY > 0));


  function search_jobs(){
    const params = new URLSearchParams({
      category: list_category.value,
      location: list_location.value,
      job_titles: list_job_title.value,
   });
   const URL_values=params.toString();
   const URL = `http://127.0.0.1:5500/Frontend/Jobs/jobs.html?${URL_values}`;
   window.location.assign(URL);
  }
  const btn_search = document.getElementById("search_btn");
  btn_search.addEventListener("click",function(event){
    event.preventDefault();
    search_jobs();
  
  });
  function make_searchable(select, placeholder) {
  const box = document.createElement("div");
  box.className = "combo";
  select.parentNode.insertBefore(box, select);
  box.appendChild(select);
  select.style.display = "none";

  const input = document.createElement("input");
  input.type = "text";
  input.className = "combo_input";
  input.autocomplete = "off";
  input.placeholder = placeholder;
  const arrow = document.createElement("span");
  arrow.className = "combo_arrow";
  const list = document.createElement("ul");
  list.className = "combo_list";
  list.hidden = true;
  box.append(input, arrow, list);

  const MAX = 60;
  let active = -1;
  let shown = [];

  const selected_label = () => {
    const o = select.options[select.selectedIndex];
    return o && o.value !== "" ? o.textContent : "";
  };

  function render(filter) {
    const q = filter.trim().toLowerCase();
    list.innerHTML = "";
    shown = [...select.options].filter(o =>
      o.value === "" ? q === "" : o.textContent.toLowerCase().includes(q));
    shown.slice(0, MAX).forEach((o, idx) => {
      const li = document.createElement("li");
      li.textContent = o.textContent;
      if (o.value === select.value) li.classList.add("selected");
      li.addEventListener("mousedown", e => { e.preventDefault(); choose(o); });
      li.addEventListener("mousemove", () => set_active(idx));
      list.appendChild(li);
    });
    if (!shown.length || shown.length > MAX) {
      const li = document.createElement("li");
      li.className = "empty";
      li.textContent = shown.length ? `${shown.length - MAX} more… keep typing` : "No result";
      list.appendChild(li);
    }
    active = -1;
  }

  function set_active(i) {
    const items = list.querySelectorAll("li:not(.empty)");
    items.forEach(li => li.classList.remove("active"));
    active = i;
    if (items[i]) { items[i].classList.add("active"); items[i].scrollIntoView({ block: "nearest" }); }
  }

  function open()  { render(""); list.hidden = false; box.classList.add("open"); }
  function close() { list.hidden = true; box.classList.remove("open"); input.value = selected_label(); }

  function choose(option) {
    select.value = option.value;
    input.value = selected_label();
    list.hidden = true;
    box.classList.remove("open");
    input.blur();
  }

  input.addEventListener("focus", () => { open(); input.select(); });
  input.addEventListener("blur", close);
  input.addEventListener("input", () => { list.hidden = false; render(input.value); });
  input.addEventListener("keydown", e => {
    const count = Math.min(shown.length, MAX);
    if (e.key === "ArrowDown") { e.preventDefault(); if (list.hidden) open(); set_active(Math.min(active + 1, count - 1)); }
    else if (e.key === "ArrowUp") { e.preventDefault(); set_active(Math.max(active - 1, 0)); }
    else if (e.key === "Enter") {
      if (list.hidden) return;              // liste fermée : Entrée lance la recherche
      e.preventDefault();
      if (shown[active]) choose(shown[active]); else if (count === 1) choose(shown[0]);
    }
    else if (e.key === "Escape") { input.blur(); }
  });
  arrow.addEventListener("mousedown", e => { e.preventDefault(); list.hidden ? input.focus() : input.blur(); });
}

make_searchable(list_job_title, "Search a job title");
make_searchable(list_location, "Search a location");
make_searchable(list_category, "Search a category");