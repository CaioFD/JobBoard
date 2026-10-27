function make_icon(id) {
  const NS = "http://www.w3.org/2000/svg";
  const svg = document.createElementNS(NS, "svg");
  svg.classList.add("icon");
  const use = document.createElementNS(NS, "use");
  use.setAttribute("href", "#" + id);
  svg.appendChild(use);
  return svg;
}
let jobs = document.getElementById("jobs");
async function get_all_jobs(){
      let response = await fetch("http://127.0.0.1:8000/api/jobs");
      if(response.ok){
        const recent_jobs = await response.json();
        console.log(recent_jobs);
        const section = document.getElementById("jobs");
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
  get_all_jobs();
  
  let list_location = document.getElementById("location_select");
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
    charge_locations();
  
    let list_category = document.getElementById("category_select");
  async function charge_categories() {
      let response = await fetch("http://127.0.0.1:8000/api/categories_HomePage");
      if(response.ok){
          const data= await response.json();
          console.log(data);
          let count=0;
          for(const i of data.categories){
              count++;
              let list_item=document.createElement("li");
              let label = document.createElement("label");
              let input = document.createElement("input");
              input.setAttribute("type","checkbox");
              let span = document.createElement("span");
              span.setAttribute("class","count");

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