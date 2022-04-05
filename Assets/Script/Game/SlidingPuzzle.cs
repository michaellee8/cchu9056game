using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using EzySlice;
using UnityEngine;
using Plane = EzySlice.Plane;
using Random = UnityEngine.Random;

namespace Script.Game
{
    public class SlidingPuzzle : MonoBehaviour
    {

        [SerializeField] private GameObject parentObject;
        [SerializeField] private GameObject mainMesh;
        [SerializeField] private Material crossSectionMaterial;

        [SerializeField] private Vector3Int finalDimension;
        private List<GameObject> _slicedMeshes = new List<GameObject>();
        private List<GameObject> _slicedScatteredMeshes;

        private Vector3Int _emptySpace = Vector3Int.zero;
        private Vector3 _midVertex;

        private IEnumerable<GameObject> Slice(GameObject obj, Vector3 begin, Vector3 step, int count)
        {
            var result = new List<GameObject>();
            var temObj = obj;

            for (var i = 1; i < count; ++i)
            {
                var newObj = temObj.SliceInstantiate(new Plane(begin + step * i, step), new TextureRegion(0.0f, 0.0f, 1.0f, 1.0f), crossSectionMaterial);
                if (newObj == null)
                {
                    print("SliceInstantiate failed");
                    break;
                }

                if (temObj.scene.name != null) Destroy(temObj);

                result.Add(newObj.Last());
                temObj = newObj.First();
            }

            result.Add(temObj);
            return result;
        }

        private void Start()
        {
            if (!mainMesh.TryGetComponent<MeshFilter>(out _))
            {
                mainMesh = GetComponentInChildren<MeshFilter>().gameObject;
            }

            var meshComp = mainMesh.GetComponent<MeshFilter>().sharedMesh;
            _midVertex = new Vector3(meshComp.vertices.Average(v => v.x), meshComp.vertices.Average(v => v.y), meshComp.vertices.Average(v => v.z));
            // var meshBound = meshComp.bounds;

            var mainObj = mainMesh;
            if (mainObj.scene.name == null) mainObj = Instantiate(mainMesh);
            ResetTransform(mainObj);

            _slicedMeshes.Add(mainObj);
            for (var i = 0; i < 3; ++i)
            {
                var temList = new List<GameObject>();

                _slicedMeshes.ForEach(o =>
                {
                    var meshBound = o.GetComponent<MeshFilter>().sharedMesh.bounds;

                    var begin = Vector3.zero;
                    begin[i] = -meshBound.size[i] / 2;

                    var step = Vector3.zero;
                    step[i] = meshBound.size[i] / finalDimension[i];

                    if (i == 0)
                    {
                        // avoid infinite normal
                        step.y += 0.001f;
                    }

                    temList.AddRange(Slice(o, begin + meshBound.center, step, finalDimension[i]));
                });
                _slicedMeshes = temList;
            }

            _slicedMeshes.ForEach(o => o.transform.parent = parentObject.transform);
            _slicedScatteredMeshes = new List<GameObject>(_slicedMeshes);

            StartCoroutine(Sep());
        }

        private static void ResetTransform(GameObject obj)
        {
            obj.transform.localPosition = Vector3.zero;
            obj.transform.localRotation = Quaternion.identity;
            obj.transform.localScale = Vector3.one;
        }

        private IEnumerator Sep()
        {
            yield return new WaitForSeconds(2);

            for (var i = 0; i < _slicedMeshes.Count; i++)
            {
                var slicedMeshComp = _slicedMeshes[i].GetComponent<MeshFilter>().sharedMesh;
                var slicedMeshMidVertex = new Vector3(slicedMeshComp.vertices.Average(v => v.x), slicedMeshComp.vertices.Average(v => v.y), slicedMeshComp.vertices.Average(v => v.z));

                StartCoroutine(SmoothLerp(_slicedMeshes[i], IndexToVector(i) * 5, 1f));
                yield return new WaitForEndOfFrame();
            }

            /*
            foreach (var slicedMesh in _slicedMeshes)
            {
                var slicedMeshComp = slicedMesh.GetComponent<MeshFilter>().sharedMesh;
                var slicedMeshMidVertex = new Vector3(slicedMeshComp.vertices.Average(v => v.x), slicedMeshComp.vertices.Average(v => v.y), slicedMeshComp.vertices.Average(v => v.z));

                StartCoroutine(SmoothLerp(slicedMesh, (slicedMeshMidVertex - _midVertex) * 1.1f, 1f));
                yield return new WaitForEndOfFrame();
            }
            */

            _emptySpace = Vector3Int.zero;
            _slicedMeshes[0].SetActive(false);

            yield return new WaitForSeconds(2);
            for (var i = 0; i < 100;)
            {
                var temVec = _emptySpace;

                var index = Random.Range(0, 3);
                var offset = Random.Range(-1, 2);
                temVec[index] += offset;

                if (Move(temVec.x, temVec.y, temVec.z))
                {
                    yield return new WaitForSeconds(0.05f);
                    ++i;
                }
            }
        }

        void OnDrawGizmos()
        {
            // Draw a yellow sphere at the transform's position
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(_emptySpace * 5, 1);
        }

        private IEnumerator SmoothLerp(GameObject obj, Vector3 offset, float time)
        {
            var startingPos = obj.transform.position;
            var finalPos = startingPos + offset;
            float elapsedTime = 0;

            while (elapsedTime < time)
            {
                obj.transform.position = Vector3.Lerp(startingPos, finalPos, elapsedTime / time);
                elapsedTime += Time.deltaTime;
                yield return null;
            }

            obj.transform.position = finalPos;
        }

        private int GetObjectIndex(int x, int y, int z)
        {
            return x * finalDimension.z * finalDimension.y + y * finalDimension.z + z;
        }

        private Vector3 IndexToVector(int index)
        {
            var z = index % finalDimension.z;
            index /= finalDimension.z;

            var y = index % finalDimension.y;
            index /= finalDimension.y;

            return new Vector3(index % finalDimension.x, y, z);
        }

        private int GetObjectIndex(Vector3Int v)
        {
            return GetObjectIndex(v.x, v.y, v.z);
        }

        public bool Move(int x, int y, int z)
        {
            if (x < 0 || x >= finalDimension.x || y < 0 || y >= finalDimension.y || z < 0 | z >= finalDimension.z)
            {
                return false;
            }

            var targetCoordinate = new Vector3Int(x, y, z);
            if (Math.Abs((targetCoordinate - _emptySpace).magnitude - 1) < float.Epsilon)
            {
                _slicedScatteredMeshes[GetObjectIndex(_emptySpace)].transform.position = _slicedScatteredMeshes[GetObjectIndex(targetCoordinate)].transform.position;

                StartCoroutine(SmoothLerp(_slicedScatteredMeshes[GetObjectIndex(targetCoordinate)], (_emptySpace - targetCoordinate) * 10, 0.05f));
                var temVec = _slicedScatteredMeshes[GetObjectIndex(targetCoordinate)];
                _slicedScatteredMeshes[GetObjectIndex(targetCoordinate)] = _slicedScatteredMeshes[GetObjectIndex(_emptySpace)];
                _slicedScatteredMeshes[GetObjectIndex(_emptySpace)] = temVec;

                _emptySpace = targetCoordinate;
                return true;
            }
            else
            {
                print("failed to move");
            }

            return false;
        }
    }
}
