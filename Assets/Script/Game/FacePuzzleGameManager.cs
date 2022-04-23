using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Votanic.vXR.vGear;

namespace Script.Game
{
    public class FacePuzzleGameManager : MonoBehaviour
    {
        [SerializeField] private GameObject facePillarPrefab;
        [SerializeField] private AnimationCurve CameraXPosition;
        [SerializeField] private Camera AnimatingCamera;
        [SerializeField] private SlidingPuzzle slidingPuzzleManager;
        [SerializeField] private GameObject vrGameObject;
        [SerializeField] private GameObject gameScene;
        [SerializeField] private GameObject animationScene;
        [SerializeField] private Color gameSkyColor;

        private GameObject cameraLookAt;
        private GameObject pillarObj;
        private float cameraAnimatedTime = 0;
        public float timeToAnimate = 10;
        public float finalX = 100;

        public bool finishInit = false;
        
        private void Start()
        {
            StartCoroutine(SpawnObject());
        }

        private IEnumerator SpawnObject()
        {
            var tem = Instantiate(facePillarPrefab, new Vector3( 500, 0, 0), Quaternion.identity);
            AnimatingCamera.transform.LookAt(tem.transform.Find("head"));
            Destroy(tem);
            
            yield return new WaitForSeconds(2);

            for (int i = 0; i < 120; ++i)
            {
                var newObj = Instantiate(facePillarPrefab, new Vector3(i * 5, 0, 0), Quaternion.identity);
                newObj.transform.parent = animationScene.transform;
                if (i == 100)
                {
                    cameraLookAt = newObj.transform.Find("head").gameObject;
                    pillarObj = newObj.transform.Find("Pillar").gameObject;
                    // slidingPuzzleManager.mainMesh = cameraLookAt;
                }

                yield return new WaitForSeconds(5 / 120f);
            }

            finishInit = true;
        }
        
        private void Update()
        {
            if (!finishInit) return;
            
            cameraAnimatedTime += Time.deltaTime;

            if (cameraAnimatedTime <= timeToAnimate)
            {
                var percentage = Mathf.Clamp(CameraXPosition.Evaluate(Mathf.Clamp(cameraAnimatedTime / timeToAnimate, 0, 1)), 0, 1);

                var transform1 = AnimatingCamera.transform;
                var transformPosition = transform1.position;
                transformPosition.x = percentage * finalX;
                transform1.position = transformPosition;

                AnimatingCamera.transform.LookAt(cameraLookAt.transform.position);
            }
            else
            {
                // slidingPuzzleManager.finalTransform = new TransformData(cameraLookAt.transform);
                if (!slidingPuzzleManager.gameObject.activeInHierarchy)
                {
                    // StartCoroutine(SmoothLerp(pillarObj, pillarObj.transform.localPosition + Vector3.down * 2, 5));
                    vrGameObject.SetActive(true);
                    gameScene.SetActive(true);
                    animationScene.SetActive(false);
                    // vGear.user.Transform(AnimatingCamera.transform.position, Vector3.zero);

                    RenderSettings.ambientLight = gameSkyColor;

                    slidingPuzzleManager.gameObject.SetActive(true);
                    StartCoroutine(FixCamera());
                }
            }
        }

        private IEnumerator FixCamera()
        {
            while (true)
            {
                var result = GameObject.Find("MainCamera [M]");
                if (!(result is null))
                {
                    result.GetComponent<Camera>().clearFlags = CameraClearFlags.SolidColor;
                    yield break;
                }

                yield return new WaitForEndOfFrame();
            }
        }

        private IEnumerator SmoothLerp(GameObject obj, Vector3 to, float time)
        {
            var startingPos = obj.transform.localPosition;

            float elapsedTime = 0;

            while (elapsedTime < time)
            {
                obj.transform.localPosition = Vector3.Lerp(startingPos, to, elapsedTime / time);
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            obj.transform.localPosition = to;
        }
    }
}
