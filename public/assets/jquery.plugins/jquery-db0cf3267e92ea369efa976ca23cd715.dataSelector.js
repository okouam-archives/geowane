/*
Copyright (c) 2009, Pim Jager
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* The name Pim Jager may not be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Pim Jager ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Pim Jager BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
(function(a){var b=function(a){return typeof a=="undefined"};a.expr[":"].data=function(c,d,e){if(b(c)||b(e))return!1;var f=e[3];if(!f)return!1;var g=f.split("="),h=g[0].charAt(g[0].length-1);if(h=="^"||h=="$"||h=="!"||h=="*"){g[0]=g[0].substring(0,g[0].length-1);if(!a.stringQuery&&h!="!")return!1}else h="=";var j=g[0],k=j.split("."),l=a(c).data(k[0]);if(b(l))return!1;if(k[1])for(i=1,x=k.length;i<x;i++){l=l[k[i]];if(b(l))return!1}if(!g[1])return!0;var m=l+"";switch(h){case"=":return m==g[1];case"!":return m!=g[1];case"^":return a.stringQuery.startsWith(m,g[1]);case"$":return a.stringQuery.endsWith(m,g[1]);case"*":return a.stringQuery.contains(m,g[1]);default:return!1}}})(jQuery)