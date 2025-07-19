(function() {
	const Filters = {};

	const SVG_NS = 'http://www.w3.org/2000/svg';

	function createElement(name, attributes = {}) {
		const el = document.createElementNS(SVG_NS, name);
		for (const [key, value] of Object.entries(attributes)) {
			el.setAttribute(key, value);
		}
		return el;
	}

	const svg = createElement('svg', {
		style: 'position:absolute; width:0; height:0; overflow:hidden',
	});

	const defs = createElement('defs');

	// --- Blur Filter ---
	const blurFilter = createElement('filter', { id: 'svgBlurFilter' });
	const feGaussianBlur = createElement('feGaussianBlur', { stdDeviation: '0 0' });
	blurFilter.appendChild(feGaussianBlur);
	defs.appendChild(blurFilter);
	Filters._svgBlurFilter = feGaussianBlur;

	// --- Drop Shadow Filter ---
	const dropShadowFilter = createElement('filter', { id: 'svgDropShadowFilter' });

	const feGaussianBlurShadow = createElement('feGaussianBlur', {
		in: 'SourceAlpha',
		stdDeviation: '3',
	});
	dropShadowFilter.appendChild(feGaussianBlurShadow);
	Filters._svgDropshadowFilterBlur = feGaussianBlurShadow;

	const feOffset = createElement('feOffset', {
		dx: '0',
		dy: '0',
		result: 'offsetblur',
	});
	dropShadowFilter.appendChild(feOffset);
	Filters._svgDropshadowFilterOffset = feOffset;

	const feFlood = createElement('feFlood', {
		'flood-color': 'rgba(0,0,0,1)',
	});
	dropShadowFilter.appendChild(feFlood);
	Filters._svgDropshadowFilterFlood = feFlood;

	const feCompositeIn = createElement('feComposite', {
		in2: 'offsetblur',
		operator: 'in',
	});
	dropShadowFilter.appendChild(feCompositeIn);

	const feCompositeOut = createElement('feComposite', {
		in2: 'SourceAlpha',
		operator: 'out',
		result: 'outer',
	});
	dropShadowFilter.appendChild(feCompositeOut);

	const feMerge = createElement('feMerge');
	const feMergeNode1 = createElement('feMergeNode');
	feMerge.appendChild(feMergeNode1);
	Filters._svgDropshadowMergeNode = feMergeNode1;

	const feMergeNode2 = createElement('feMergeNode');
	feMerge.appendChild(feMergeNode2);

	dropShadowFilter.appendChild(feMerge);
	defs.appendChild(dropShadowFilter);

	svg.appendChild(defs);
	document.documentElement.appendChild(svg);

	// --- Dynamic Adjustment ---
	const blurScale = 1;
	const scale = document.body.clientWidth / 1280;
	const shadowStrength = 1;
	const angle = 45 * (Math.PI / 180);

	Filters._svgDropshadowFilterBlur.setAttribute('stdDeviation', `${blurScale} ${blurScale}`);
	Filters._svgDropshadowFilterOffset.setAttribute('dx', (Math.cos(angle) * shadowStrength * scale).toFixed(2));
	Filters._svgDropshadowFilterOffset.setAttribute('dy', (Math.sin(angle) * shadowStrength * scale).toFixed(2));
	Filters._svgDropshadowFilterFlood.setAttribute('flood-color', 'rgba(0, 0, 0, 1)');
	Filters._svgDropshadowMergeNode.setAttribute('in', 'SourceGraphic');

})();
